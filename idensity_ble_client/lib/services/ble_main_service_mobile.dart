import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:idensity_ble_client/services/ble_main_service.dart';
import 'package:idensity_ble_client/services/ble_main_state.dart';

class BleMainServiceMobile implements BleMainService {

  BleMainServiceMobile(){
    _subsribe();
  }

  StreamSubscription<List<ScanResult>>? _scanSubscription;


  @override
  Future<void> setLogLevel() async {
    await FlutterBluePlus.setLogLevel(LogLevel.verbose, color: false);
  }

  @override
  Future<void> enableBle() async {
    final isSupported = await FlutterBluePlus.isSupported;
    if (isSupported == false) {
      log("Bluetooth not supported by this mobile device");
       _stateController.add(BleMainState.notSupported);
      return;
    }
    final state = await FlutterBluePlus.adapterState.first;
    log(state.toString());
    if (state != BluetoothAdapterState.on) {
      log("Bluetooth off");
      _stateController.add(BleMainState.off);
      return;
    }
      
    await scanDevices();
  }

  @override
  List<ScanResult> scanResults = [];
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  
  @override
  Future<void> scanDevices() async{ 
    scanResults.clear();
    const timeout = Duration(seconds: 20);
    log('Scanning for devices...');
    _stateController.add(BleMainState.scanning);
    await FlutterBluePlus.startScan(timeout: timeout);
    final sub = FlutterBluePlus.scanResults.expand((e) => e).listen((device) {
      if (device.advertisementData.advName.isNotEmpty &&
          !scanResults.any((result) {
            return result.device.remoteId == device.device.remoteId;
          })) {
        scanResults.add(device);
        _stateController.add(BleMainState.scanning);
        log(
          '${device.device.remoteId}: "${device.advertisementData.advName}" found!',
        );
      }
    });
    await Future.delayed(timeout);
    sub.cancel();
    log('Found ${scanResults.length} devices');
    _stateController.add(BleMainState.on);
    
  }

  void _subsribe() {
    FlutterBluePlus.adapterState.listen((state) async {
      adapterState = state;
      log(state.toString());
      if (state == BluetoothAdapterState.on) {
        await scanDevices();
        _stateController.add(BleMainState.on);
      } else {
        _stateController.add(BleMainState.off);
      }
    });
  }

  @override
  Stream<BleMainState> get bleMainState => _stateController.stream;
  final StreamController<BleMainState> _stateController =
      StreamController<BleMainState>.broadcast();
}
