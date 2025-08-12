import 'package:idensity_ble_client/models/bluetooth/bluetooth_settings.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/ethernet/ethernet_settings.dart';

class ConnectionSettings {
  ConnectionType connectionType = ConnectionType.bluetooth;
  EthernetSettings ethernetSettings = EthernetSettings();
  BluetoothSettings bluetoothSettings = BluetoothSettings();
}