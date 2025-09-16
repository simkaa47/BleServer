import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/bluetooth/bluetooth_connection.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/scan_result.dart';
import 'package:idensity_ble_client/models/scan_state.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/services/scan_service.dart';
import 'package:rxdart/subjects.dart';
import 'package:universal_ble/universal_ble.dart';

class BleScanService implements ScanService {
  BleScanService({required this.deviceService}) {
    _subsribe();
  }
  final DeviceService deviceService;

  List<BlueScanResult> results = [];
  @override
  List<BlueScanResult> get scanResults => results;

  @override
  Stream<ScanState> get scanState => _stateController.stream;
  final BehaviorSubject<ScanState> _stateController =
      BehaviorSubject<ScanState>();

  StreamSubscription<BleDevice>? subscription;
  StreamSubscription<AvailabilityState>? adapterStateSubscription;

  @override
  Future<void> startScan({required int duration}) async {
    results.clear();
    _stateController.add(ScanState.scanning);
    log('Scanning for devices...');
    var services = [BluetoothConnection.serviceUuid];
    UniversalBle.timeout = const Duration(seconds: 15);
    subscription = UniversalBle.scanStream.listen((BleDevice bleDevice) {
      if (bleDevice.name != null && bleDevice.name!.isNotEmpty) {
        if (!results.any((result) {
          return result.advName == bleDevice.name;
        })) {
          final BlueScanResult result = BlueScanResult();
          result.advName = bleDevice.name!;
          result.macAddress = bleDevice.deviceId;
          results.add(result);

          _stateController.add(ScanState.scanning);
          log('${bleDevice.deviceId}: "${bleDevice.name}" found!');
        }
      }
    });
    debugPrint("Старт сканирования");
    try {
      await UniversalBle.startScan(
        scanFilter: ScanFilter(withServices: services),
      );
    } catch (e) {
      debugPrint("Ошибка при запуске сканирования - $e");
    }
  }

  @override
  Future<void> stopScan() async {
    try {
      await UniversalBle.stopScan();
      _stateController.add(ScanState.on);
      await subscription?.cancel();
    } catch (e) {
      debugPrint("Ошибка при остановке сканирования - $e");
    }
  }

  @override
  void dispose() async {
    _stateController.close();
    await subscription?.cancel();
    await adapterStateSubscription?.cancel();
  }

  @override
  Future<void> saveDevices(List<IdensityScanResult> results) async {
    List<Device> devices =
        results.map((result) {
          final device = Device();
          if (result is BlueScanResult) {
            device.connectionSettings.bluetoothSettings.deviceName =
                result.advName;
            device.connectionSettings.bluetoothSettings.macAddress =
                result.macAddress;
            device.name = result.advName;
          }
          return device;
        }).toList();
    await deviceService.addDevices(devices);
  }

  void _subsribe() {
    adapterStateSubscription = UniversalBle.availabilityStream.listen((
      state,
    ) async {
      if (state == AvailabilityState.poweredOn) {
        _stateController.add(ScanState.on);
      } else {
        try {
          await stopScan();
        } catch (e) {
          debugPrint("Error with stop scan");
        }
        _stateController.add(ScanState.off);
      }
    });
  }
}
