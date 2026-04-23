import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/bluetooth/bluetooth_settings.dart';
import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:universal_ble/universal_ble.dart';

class BleConnection implements Connection {
  static const String _serviceUuid = 'd973f2e0-b19e-11e2-9e96-0800200c9a66';
  static const String _writeCharUuid = 'd973f2e2-b19e-11e2-9e96-0800200c9a66';
  static const String _readCharUuid = 'd973f2e1-b19e-11e2-9e96-0800200c9a66';

  BleConnection(BluetoothSettings settings)
      : _bleDevice = BleDevice(
          deviceId: settings.macAddress,
          name: settings.deviceName,
        ) {
    _connectStateSub = _bleDevice.connectionStream.listen((isConnected) {
      debugPrint('BLE connected: $isConnected');
    });
  }

  final BleDevice _bleDevice;
  BleCharacteristic? _charRead;
  BleCharacteristic? _charWrite;
  StreamSubscription<List<int>>? _readSub;
  StreamSubscription<bool>? _connectStateSub;
  Completer<List<int>>? _readCompleter;
  int? _expectedLen;
  int _receivedLen = 0;
  List<int> _inputBuf = [];

  @override
  ConnectionType get connectionType => ConnectionType.bluetooth;

  @override
  Stream<List<int>> get spectrumStream => Stream.empty(); // TODO: BLE characteristic subscription

  @override
  Future<List<int>> readBytes(List<int> request, {int? expectedRespLen}) async {
    _expectedLen = expectedRespLen;
    _receivedLen = 0;

    final state = await _bleDevice.connectionState;
    if (state != BleConnectionState.connected || _charWrite == null || _charRead == null) {
      await _connectAndSubscribe();
    }

    _readCompleter = Completer<List<int>>();
    _inputBuf = [];
    try {
      await _charWrite!.write(request);
      return await _readCompleter!.future.timeout(const Duration(milliseconds: 1000));
    } on TimeoutException {
      _readCompleter = null;
      rethrow;
    } catch (e) {
      _readCompleter = null;
      rethrow;
    }
  }

  Future<void> _connectAndSubscribe() async {
    // If characteristics are missing but device thinks it's connected — reconnect clean
    if (_charRead == null || _charWrite == null) {
      if (await _bleDevice.connectionState == BleConnectionState.connected) {
        await _bleDevice.disconnect();
      }
    }
    if (await _bleDevice.connectionState == BleConnectionState.disconnected) {
      await _bleDevice.connect();
      if (!Platform.isLinux) {
        final mtu = await _bleDevice.requestMtu(256);
        debugPrint('MTU = $mtu bytes');
      }
    }

    await _readSub?.cancel();

    _charWrite = await _bleDevice.getCharacteristic(_writeCharUuid, service: _serviceUuid);
    _charRead = await _bleDevice.getCharacteristic(_readCharUuid, service: _serviceUuid);

    if (_charRead!.notifications.isSupported) {
      await _charRead!.notifications.subscribe();
      _readSub = _charRead!.onValueReceived.listen(
        (value) {
          if (_readCompleter == null || _readCompleter!.isCompleted) return;
          _receivedLen += value.length;
          _inputBuf.addAll(value);
          if (_expectedLen == null || _receivedLen >= _expectedLen!) {
            _readCompleter!.complete(_inputBuf);
          }
        },
        onError: (error) {
          if (_readCompleter != null && !_readCompleter!.isCompleted) {
            _readCompleter!.completeError(error);
          }
        },
      );
    }
    log('BleConnection: subscribe complete');
  }

  @override
  Future<void> dispose() async {
    await _charRead?.unsubscribe();
    await _connectStateSub?.cancel();
    await _readSub?.cancel();
    await _bleDevice.disconnect();
  }
}
