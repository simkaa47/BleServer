import 'dart:async';

import 'package:idensity_ble_client/models/bluetooth/bluetooth_connection.dart';
import 'package:idensity_ble_client/models/bluetooth/bluetooth_settings.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/ethernet/ethernet_settings.dart';
import 'package:idensity_ble_client/models/indication.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';

class Device {
  bool connected = false;
  IndicationData indicationData = IndicationData();
  ConnectionType connectionType = ConnectionType.bluetooth;
  EthernetSettings ethernetSettings = EthernetSettings();
  BluetoothSettings bluetoothSettings = BluetoothSettings();
  String name = "";
  BluetoothConnection? _bluetoothConnection;
  BluetoothConnection? get bluetoothConnection => _bluetoothConnection;

  final _indicationDataController =
      StreamController<IndicationData>.broadcast();
  Stream<IndicationData> get dataStream => _indicationDataController.stream;

  dispose() async {
    await _bluetoothConnection?.dispose();
    _indicationDataController.close();
  }

  Future<void> updateIndicationData(ModbusService service) async {
    await service.getIndicationData(this);
    _indicationDataController.add(indicationData);
  }

  Future<List<int>> readBytes(List<int> request) async {
    if (connectionType == ConnectionType.bluetooth) {
      _bluetoothConnection ??= BluetoothConnection(
        remoteId: bluetoothSettings.macAddress,
      );
      _bluetoothConnection!.remoteId = bluetoothSettings.macAddress;
      final response = await _bluetoothConnection!.readBytes(request);
      return response;
    } else {
      throw Exception("Needs to be implemented");
    }
  }
}
