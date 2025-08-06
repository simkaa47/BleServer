import 'package:idensity_ble_client/models/scan_result.dart';
import 'package:idensity_ble_client/models/scan_state.dart';

class ScanService {
  List<IdensityScanResult> get scanResults => throw Exception("Needs to be implemented");

  Future<void> stopScan() async {
    throw Exception("Needs to be implemented");
  }

  Future<void> startScan({required int duration}) async {
    throw Exception("Needs to be implemented");
  }

  Stream<ScanState> get scanState => throw Exception("Needs to be implemented");

  void dispose() {
    throw Exception("Needs to be implemented");
  }

  Future<void> saveDevices(List<IdensityScanResult> results) {
    throw Exception("Needs to be implemented");
  }
}
