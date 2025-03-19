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
      return;
    }
    final state = await FlutterBluePlus.adapterState.first;
    log(state.toString());
    if (state != BluetoothAdapterState.on) {
      log("Bluetooth off");
      return;
    }
      _scanSubscription?.cancel();  
      _scanSubscription = FlutterBluePlus.onScanResults.listen((results) {
      scanResults = results;
      if (results.isNotEmpty) {
        ScanResult r = results.last; // the most recently found device
        log('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
      }
    },  onError: (e) => log(e.toString()));
    await scanDevices();
  }

  @override
  List<ScanResult> scanResults = [];
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  
  @override
  Future<void> scanDevices() async{
    const timeout = Duration(seconds: 20);
    scanResults.clear();
    final state = await FlutterBluePlus.adapterState.first;
    if(state == BluetoothAdapterState.on){
      log('Scanning for devices...');
      _stateController.add(BleMainState.scanning);
      await FlutterBluePlus.startScan(timeout: timeout);
    }
    
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
