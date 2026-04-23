import 'package:idensity_ble_client/models/scan_result.dart';
import 'package:idensity_ble_client/models/scan_state.dart';

abstract interface class ScanService {
  List<IdensityScanResult> get scanResults;
  Stream<ScanState> get scanState;

  Future<void> startScan({required int duration});
  Future<void> stopScan();
  Future<void> saveDevices(List<IdensityScanResult> results);
  void dispose();
}
