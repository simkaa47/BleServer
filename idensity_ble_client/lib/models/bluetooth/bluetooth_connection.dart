import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';

class BluetoothConnection {
  static const String serviceUuid = "d973f2e0-b19e-11e2-9e96-0800200c9a66";
  static const String characteristicWriteUuid =
      "d973f2e2-b19e-11e2-9e96-0800200c9a66";
  static const String characteristicReadUuid =
      "d973f2e1-b19e-11e2-9e96-0800200c9a66";
  BleCharacteristic? _characteristicRead;
  BleCharacteristic? _characteristicWrite;
  final BleDevice bleDevice;
  StreamSubscription<List<int>>? _readSubscription;
  Completer<List<int>>? _readCompleter;
  late StreamSubscription<bool> _connectStateSubscription;
  bool connected = false;

  BluetoothConnection({required this.bleDevice}) {
    _connectStateSubscription = bleDevice.connectionStream.listen((
      isConnected,
    ) {
      debugPrint('Is device connected?: $isConnected');
      connected = isConnected;
    });
  }

  Future<List<int>> readBytes(List<int> request, {int timeoutMs = 1000}) async {
    //await connectTest();
    if (!(await bleDevice.connectionState == BleConnectionState.connected) ||
        _characteristicWrite == null ||
        _characteristicRead == null) {
      await _connect();
    }
    final duration = Duration(milliseconds: timeoutMs);
    _readCompleter = Completer<List<int>>();
    try {
      await _characteristicRead!.write(request);
      final response = await _readCompleter!.future.timeout(duration);
      return response;
    } on TimeoutException {
      _readCompleter = null;
      rethrow;
    } catch (e) {
      _readCompleter = null;
      rethrow;
    }
  }

  Future<void> _connect() async {
    if (_characteristicRead == null || _characteristicWrite == null) {
      final connectionState = await bleDevice.connectionState;
      if (connectionState == BleConnectionState.connected) {
        try {
          await bleDevice.disconnect();
        } catch (e) {
          throw Exception("Error with disconnect method of BleDevice - $e");
        }
      }
    }
    final connectionState = await bleDevice.connectionState;
    if (connectionState == BleConnectionState.disconnected) {
      try {
        await bleDevice.connect();
        if (!Platform.isLinux) {
          var result = await bleDevice.requestMtu(256);
          debugPrint("MTU = $result bytes");
        }
      } catch (e) {
        throw Exception("Error with connect method of BleDevice - $e");
      }
    }
    _readSubscription?.cancel();

    _characteristicWrite = await bleDevice.getCharacteristic(
      characteristicWriteUuid,
      service: serviceUuid,
    );
    _characteristicRead = await bleDevice.getCharacteristic(
      characteristicReadUuid,
      service: serviceUuid,
    );
    final isNotificationsSupported =
        _characteristicRead!.notifications.isSupported;
    if (isNotificationsSupported && _characteristicRead != null) {
      await _characteristicRead!.notifications.subscribe();
      _readSubscription = _characteristicRead!.onValueReceived.listen(
        (value) {
          debugPrint("We've gotten some value $value");
          if (_readCompleter != null && !_readCompleter!.isCompleted) {
            _readCompleter!.complete(value);
          }
        },
        onError: (error) {
          if (_readCompleter != null && !_readCompleter!.isCompleted) {
            _readCompleter!.completeError(error);
          }
        },
      );
    }

    log("End of connect method");
  }

  Future<void> dispose() async {
    await _characteristicRead?.unsubscribe();
    await _connectStateSubscription.cancel();
    await _readSubscription?.cancel();
    await bleDevice.disconnect();
  }
}
