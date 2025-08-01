import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';
import 'package:idensity_ble_client/models/scan_result.dart';
import 'package:idensity_ble_client/models/scan_state.dart';
import 'package:idensity_ble_client/services/scan_service.dart';

class BleScanService implements ScanService {
  BleScanService() {
    _subsribe();
  }

  List<BlueScanResult> results = [];
  @override
  List<BlueScanResult> get scanResults => results;

  @override
  Stream<ScanState> get scanState => _stateController.stream;
  final StreamController<ScanState> _stateController =
      StreamController<ScanState>.broadcast();

  StreamSubscription<ScanResult>? subscription;
  StreamSubscription<BluetoothAdapterState>? adapterStateSubscription;

  @override
  Future<void> startScan({required int duration}) async {
    results.clear();
    _stateController.add(ScanState.scanning);
    final timeout = Duration(seconds: duration);
    log('Scanning for devices...');
    await FlutterBluePlus.startScan(timeout: timeout);
    subscription = FlutterBluePlus.scanResults.expand((e) => e).listen((
      device,
    ) {
      if (device.advertisementData.advName.isNotEmpty &&
          !results.any((result) {
            return result.advName == device.device.advName;
          })) {
        final BlueScanResult result = BlueScanResult();
        result.advName = device.device.advName;
        result.macAddress = device.device.remoteId.str;
        results.add(result);
        _stateController.add(ScanState.scanning);
        log(
          '${device.device.remoteId}: "${device.advertisementData.advName}" found!',
        );
      }
    });
    await Future.delayed(timeout);
    subscription?.cancel();

    log('Found ${results.length} devices');
    _stateController.add(ScanState.on);
  }

  @override
  Future<void> stopScan() async {
    _stateController.add(ScanState.on);
    subscription?.cancel();
  }

  @override
  void dispose() {
    _stateController.close();
    subscription?.cancel();
    adapterStateSubscription?.cancel();
  }

  @override
  Future<void> saveDevice(IdensityScanResult result) {
    // TODO: implement saveDevice
    throw UnimplementedError();
  }

  void _subsribe() {
    adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) async {
      log(state.toString());
      if (state == BluetoothAdapterState.on) {
        _stateController.add(ScanState.on);
      } else {
        _stateController.add(ScanState.off);
      }
    });
  }
}
