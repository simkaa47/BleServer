import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:idensity_ble_client/flutter_blue_plus_wrapper/src/wrapper/flutter_blue_plus_wrapper.dart';

class BluetoothConnection {
  BluetoothConnection({required this.remoteId});
  static const String serviceUuid = "d973f2e0-b19e-11e2-9e96-0800200c9a66";
  static const String characteristicWriteUuid =
      "d973f2e2-b19e-11e2-9e96-0800200c9a66";
  static const String characteristicReadUuid =
      "d973f2e1-b19e-11e2-9e96-0800200c9a66";
  String remoteId;
  BluetoothCharacteristic? _characteristicRead;
  BluetoothCharacteristic? _characteristicWrite;
  BluetoothDevice? _bleDevice;
  StreamSubscription<List<int>>? _readSubscription;
  Completer<List<int>>? _readCompleter;
  StreamSubscription<ScanResult>? _subscription;

  Future<List<int>> readBytes(List<int> request, {int timeoutMs = 1000}) async {
    if (_bleDevice == null || !_bleDevice!.isConnected) {
      await _connect();
    }
    final duration = Duration(milliseconds: timeoutMs);
    _readCompleter = Completer<List<int>>();
    try {
      await _characteristicRead!.write(request);
      if (Platform.isWindows) {
        await Future.delayed(const Duration(milliseconds: 100));
        await _characteristicRead?.read();
      }
      final response = await _readCompleter!.future.timeout(duration);
      return response;
    } on TimeoutException {
      // При тайм-ауте completer уже не нужен
      _readCompleter = null;
      rethrow;
    } catch (e) {
      _readCompleter = null;
      rethrow;
    }
  }

  Future<void> _connect() async {
    if (_bleDevice == null || _bleDevice!.remoteId.toString() != remoteId) {
      await _bleDevice?.disconnect();
      if (!Platform.isWindows) {
        _bleDevice = BluetoothDevice.fromId(remoteId);
      } else {
        await FlutterBluePlusWrapper.startScan(
          timeout: const Duration(seconds: 12),
          withServices: [Guid(serviceUuid)],
        );
        _subscription = FlutterBluePlusWrapper.scanResults.expand((e) => e).listen((
          result,
        ) async {
          if (result.device.remoteId.str == remoteId) {
            _bleDevice = result.device;
            await FlutterBluePlusWrapper.stopScan();
            _subscription?.cancel();
          }
        });
        await FlutterBluePlusWrapper.isScanning.where((val) => val == false).first;
        _subscription?.cancel();
      }
    }
    if (_bleDevice != null) {
      await _bleDevice!.connect();
      List<BluetoothService> services = await _bleDevice!.discoverServices();
      final service =
          services
              .where((service) => service.uuid.toString() == serviceUuid)
              .firstOrNull;
      debugPrint('Успех!');
      if (service == null) return;

      _characteristicWrite =
          service.characteristics
              .where(
                (characteristic) =>
                    characteristic.uuid.toString() == characteristicWriteUuid,
              )
              .firstOrNull;
      _characteristicRead =
          service.characteristics
              .where(
                (characteristic) =>
                    characteristic.uuid.toString() == characteristicReadUuid,
              )
              .firstOrNull;
      if (_characteristicRead != null) {
        debugPrint("Read characteristic was founded");
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
        _bleDevice!.cancelWhenDisconnected(_readSubscription!);
        if (!Platform.isWindows) {
          await _characteristicRead!.setNotifyValue(true);
        }
      }
    } else {
      throw Exception(
        "Не удалось подлкючиться к устройству с MAC адресом $remoteId",
      );
    }
  }

  Future<void> dispose() async {
    await _bleDevice?.disconnect();
    _subscription?.cancel();
  }

  Future<void> onWindowsPlatformConnect() async {}
}
