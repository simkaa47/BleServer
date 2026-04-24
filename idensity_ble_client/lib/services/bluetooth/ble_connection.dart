import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/adc/adc_frame.dart';
import 'package:idensity_ble_client/models/bluetooth/bluetooth_settings.dart';
import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:universal_ble/universal_ble.dart';

class BleConnection implements Connection {
  static const String _serviceUuid    = 'd973f2e0-b19e-11e2-9e96-0800200c9a66';
  static const String _writeCharUuid  = 'd973f2e2-b19e-11e2-9e96-0800200c9a66';
  static const String _readCharUuid   = 'd973f2e1-b19e-11e2-9e96-0800200c9a66';
  static const String _spectrumCharUuid = 'd973f2e3-b19e-11e2-9e96-0800200c9a66';

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
  BleCharacteristic? _charSpectrum;
  StreamSubscription<List<int>>? _readSub;
  StreamSubscription<List<int>>? _spectrumSub;
  StreamSubscription<bool>? _connectStateSub;
  Completer<List<int>>? _readCompleter;
  int? _expectedLen;
  int _receivedLen = 0;
  List<int> _inputBuf = [];

  final _spectrumController = StreamController<AdcFrame>.broadcast();

  // Level 1: BLE chunk reassembly
  final List<int> _bleBuffer = [];

  // Level 2: multi-packet reassembly
  var _nextPacketNum = 1;
  final List<int> _samples = [];

  @override
  ConnectionType get connectionType => ConnectionType.bluetooth;

  @override
  Stream<AdcFrame> get spectrumStream => _spectrumController.stream;

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
    await Future.wait([
      _charRead?.unsubscribe().catchError((_) {}) ?? Future.value(),
      _charSpectrum?.unsubscribe().catchError((_) {}) ?? Future.value(),
      _readSub?.cancel() ?? Future.value(),
      _spectrumSub?.cancel() ?? Future.value(),
    ]);
    _charWrite = null;
    _charRead = null;
    _charSpectrum = null;

    try {
      if (await _bleDevice.connectionState == BleConnectionState.connected) {
        await _bleDevice.disconnect();
      }
    } catch (_) {}

    await UniversalBle.connect(_bleDevice.deviceId, timeout: const Duration(seconds: 90));
    if (!Platform.isLinux) {
      final mtu = await _bleDevice.requestMtu(256);
      debugPrint('MTU = $mtu bytes');
    }

    await _readSub?.cancel();

    _charWrite = await _bleDevice.getCharacteristic(_writeCharUuid, service: _serviceUuid, preferCached: false);
    _charRead = await _bleDevice.getCharacteristic(_readCharUuid, service: _serviceUuid, preferCached: false);
    _charSpectrum = await _bleDevice.getCharacteristic(_spectrumCharUuid, service: _serviceUuid, preferCached: false);

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

    if (_charSpectrum!.notifications.isSupported) {
      await _charSpectrum!.notifications.subscribe();
      _spectrumSub = _charSpectrum!.onValueReceived.listen(_onSpectrumChunk);
    }

    log('BleConnection: subscribe complete');
  }

  // Level 1: accumulate MTU chunks until terminator '#' (0x23 = 35)
  void _onSpectrumChunk(List<int> chunk) {
    debugPrint('Нотификация от х-ки спектра - $chunk');
    _bleBuffer.addAll(chunk);
    if (_bleBuffer.last != 35) return;
    _parsePacket(List.unmodifiable(_bleBuffer));
    _bleBuffer.clear();
  }

  // Level 2: parse one complete application packet, assemble multi-packet frame
  void _parsePacket(List<int> data) {
    if (data.length < 10) return;

    final header = ascii.decode(data.sublist(0, 5));
    final meta = ascii.decode(data.sublist(0, 10)).split(',');
    if (meta.length < 3) return;

    final count = int.tryParse(meta[1].trim());
    final packetNum = int.tryParse(meta[2].trim().replaceAll(RegExp(r'\D'), ''));
    if (count == null || packetNum == null) return;

    if (packetNum != _nextPacketNum) {
      _nextPacketNum = 1;
      _samples.clear();
      return;
    }
    _nextPacketNum = (packetNum + 1 > count) ? 1 : packetNum + 1;

    AdcFrameType? type;
    int bytesPerSample;
    int dataEnd;

    switch (header) {
      case '*AOLV':
        type = AdcFrameType.oscilloscope;
        bytesPerSample = 2;
        dataEnd = data.length - 1;
      case '*AML1':
        type = AdcFrameType.spectrumPartial;
        bytesPerSample = 2;
        dataEnd = data.length < 1035 ? data.length - 1 : 1034;
      case '*AML2':
        type = AdcFrameType.spectrumFull;
        bytesPerSample = 2;
        dataEnd = data.length < 1035 ? data.length - 1 : 1034;
      case '*AML3':
        type = AdcFrameType.counters;
        bytesPerSample = 4;
        dataEnd = data.length - 1;
      default:
        return;
    }

    if (packetNum == 1) _samples.clear();

    for (var i = 10 + bytesPerSample - 1; i < dataEnd; i += bytesPerSample) {
      var sample = 0;
      for (var j = i; j > i - bytesPerSample; j--) {
        sample += data[j] << ((j - i + bytesPerSample - 1) * 8);
      }
      _samples.add(sample);
    }

    if (packetNum >= count) {
      _spectrumController.add(AdcFrame(type: type, samples: List.from(_samples)));
      _samples.clear();
    }
  }

  @override
  Future<void> dispose() async {
    await _charRead?.unsubscribe();
    await _charSpectrum?.unsubscribe();
    await _connectStateSub?.cancel();
    await _readSub?.cancel();
    await _spectrumSub?.cancel();
    await _spectrumController.close();
    await _bleDevice.disconnect();
  }
}
