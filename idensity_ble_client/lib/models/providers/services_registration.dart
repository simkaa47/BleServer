import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/services/bluetooth/ble_scan_service.dart';
import 'package:idensity_ble_client/services/ethernet/ethernet_scan_service.dart';
import 'package:idensity_ble_client/services/scan_service.dart';

final scanServiceProvider = Provider.family<ScanService, ConnectionType>((ref, conType) {
  ScanService? service;
  switch (conType) {
    case ConnectionType.bluetooth:
      service =  BleScanService();      
    default:
    service =  EthernetScanService();
  }
  ref.onDispose(()=> service?.dispose());
  return service;
});

final connectionTypeProvider = StateProvider<ConnectionType>((ref) => ConnectionType.bluetooth);

