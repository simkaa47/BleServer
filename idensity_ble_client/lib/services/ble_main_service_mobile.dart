import 'dart:async';
import 'dart:developer';


import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';
import 'package:idensity_ble_client/models/scan_state.dart';
import 'package:idensity_ble_client/services/ble_main_service.dart';

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
       _stateController.add(ScanState.notSupported);
      return;
    }
    final state = await FlutterBluePlus.adapterState.first;
    log(state.toString());
    if (state != BluetoothAdapterState.on) {
      log("Bluetooth off");
      _stateController.add(ScanState.off);
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
    _stateController.add(ScanState.scanning);
    await FlutterBluePlus.startScan(timeout: timeout);
    final sub = FlutterBluePlus.scanResults.expand((e) => e).listen((device) {
      if (device.advertisementData.advName.isNotEmpty &&
          !scanResults.any((result) {
            return result.device.remoteId == device.device.remoteId;
          })) {
        scanResults.add(device);
        _stateController.add(ScanState.scanning);
        log(
          '${device.device.remoteId}: "${device.advertisementData.advName}" found!',
        );
      }
    });
    await Future.delayed(timeout);
    sub.cancel();
    log('Found ${scanResults.length} devices');
    _stateController.add(ScanState.on);
    
  }

  void _subsribe() {
    FlutterBluePlus.adapterState.listen((state) async {
      adapterState = state;
      log(state.toString());
      if (state == BluetoothAdapterState.on) {
        await scanDevices();
        _stateController.add(ScanState.on);
      } else {
        _stateController.add(ScanState.off);
      }
    });
  }

  @override
  Stream<ScanState> get bleMainState => _stateController.stream;
  final StreamController<ScanState> _stateController =
      StreamController<ScanState>.broadcast();
}
