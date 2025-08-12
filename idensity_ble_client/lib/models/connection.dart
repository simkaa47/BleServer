import 'package:idensity_ble_client/models/bluetooth/bluetooth_connection.dart';
import 'package:idensity_ble_client/models/connection_settings.dart';
import 'package:idensity_ble_client/models/connection_type.dart';

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
        remoteId: connectionSettings.bluetoothSettings.macAddress,
      );
      _bluetoothConnection!.remoteId = connectionSettings.bluetoothSettings.macAddress;
      final response = await _bluetoothConnection!.readBytes(request);
      return response;
    } else {
      throw Exception("Needs to be implemented");
    }
  }
}
