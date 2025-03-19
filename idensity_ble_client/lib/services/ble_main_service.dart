import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:idensity_ble_client/services/ble_main_state.dart';

abstract class BleMainService {
  Future<void> setLogLevel();
  Future<void> enableBle();
  Future<void> scanDevices();
  List<ScanResult> scanResults = [];
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  Stream<BleMainState> get bleMainState;
}