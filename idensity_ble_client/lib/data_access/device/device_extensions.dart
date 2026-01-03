import 'package:drift/drift.dart';
import 'package:idensity_ble_client/data_access/app_database.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';

extension DeviceToCompanion on Device{
  DeviceRowsCompanion toCompanion(){
    return DeviceRowsCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      connectionType: Value(connectionSettings.connectionType.index),
      ip: Value(connectionSettings.ethernetSettings.ip),
      macAddress: Value(connectionSettings.bluetoothSettings.macAddress),
      name: Value(name)
    );
  }
}

extension DeviceFromRow on DeviceRow{
  Device toModel(){
    final device = Device();
    device.id = id;
    device.connectionSettings.connectionType = ConnectionType.values[connectionType];
    device.connectionSettings.ethernetSettings.ip = ip;
    device.connectionSettings.bluetoothSettings.macAddress = macAddress;
    device.connectionSettings.bluetoothSettings.deviceName = name;
    device.name = name;

    return device;
  }
}