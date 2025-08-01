import 'package:idensity_ble_client/models/scan_result.dart';
import 'package:idensity_ble_client/models/scan_state.dart';
import 'package:idensity_ble_client/services/scan_service.dart';

class EthernetScanService implements ScanService {
  @override
  // TODO: implement bleMainState
  Stream<ScanState> get scanState => throw UnimplementedError();
  

  @override
  Future<void> startScan({required int duration}) {
    // TODO: implement startScan
    throw UnimplementedError();
  }

  @override
  Future<void> stopScan() {
    // TODO: implement stopScan
    throw UnimplementedError();
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
  }
  
  @override
  Future<void> saveDevice(IdensityScanResult result) {
    // TODO: implement saveDevice
    throw UnimplementedError();
  }

  @override
  List<IdensityScanResult> scanResults = [];

}