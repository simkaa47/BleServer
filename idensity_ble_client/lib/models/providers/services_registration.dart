import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/services/bluetooth/ble_scan_service.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/services/ethernet/ethernet_scan_service.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';
import 'package:idensity_ble_client/services/scan_service.dart';

final scanServiceProvider = Provider.family<ScanService, ConnectionType>((
  ref,
  conType,
) {
  final deviceService = ref.read(deviceServiceProvider);
  ScanService? service;
  switch (conType) {
    case ConnectionType.bluetooth:
      service = BleScanService(deviceService: deviceService);
    default:
      service = EthernetScanService(deviceService: deviceService);
  }
  ref.onDispose(() => service?.dispose());
  return service;
});

final connectionTypeProvider = StateProvider<ConnectionType>(
  (ref) => ConnectionType.bluetooth,
);

final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService();
});

final modbusServiceProvider = Provider<ModbusService>((ref) {
  return ModbusService();
});
