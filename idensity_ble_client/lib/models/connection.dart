import 'package:idensity_ble_client/models/bluetooth/bluetooth_connection.dart';
import 'package:idensity_ble_client/models/connection_settings.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:universal_ble/universal_ble.dart';

class Connection {
  Connection(this.connectionSettings);

  BluetoothConnection? _bluetoothConnection;
  BluetoothConnection? get bluetoothConnection => _bluetoothConnection;
  ConnectionSettings connectionSettings;
  String name = "";

  dispose() async {
    await _bluetoothConnection?.dispose();
  }

  Future<List<int>> readBytes(List<int> request) async {
    if (connectionSettings.connectionType == ConnectionType.bluetooth) {
      _bluetoothConnection ??= BluetoothConnection(
        bleDevice: BleDevice(deviceId: connectionSettings.bluetoothSettings.macAddress, name: connectionSettings.bluetoothSettings.deviceName),
      );      
      final response = await _bluetoothConnection!.readBytes(request);
      return response;
    } else {
      throw Exception("Needs to be implemented");
    }
  }
}
