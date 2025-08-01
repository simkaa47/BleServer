import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';
import 'package:idensity_ble_client/models/scan_state.dart';

abstract class BleMainService {
  Future<void> setLogLevel();
  Future<void> enableBle();
  Future<void> scanDevices();
  List<ScanResult> scanResults = [];
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  Stream<ScanState> get bleMainState;
}