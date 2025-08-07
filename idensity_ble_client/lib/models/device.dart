import 'package:idensity_ble_client/models/bluetooth/bluetooth_connection.dart';
import 'package:idensity_ble_client/models/bluetooth/bluetooth_settings.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/ethernet/ethernet_settings.dart';
import 'package:idensity_ble_client/models/indication.dart';

class Device {
  bool connected = false; 
  IndicationData indicationData = IndicationData();
  ConnectionType connectionType = ConnectionType.bluetooth;
  EthernetSettings ethernetSettings = EthernetSettings();
  BluetoothSettings bluetoothSettings = BluetoothSettings();
  String name  = "";
  BluetoothConnection? _bluetoothConnection;
  BluetoothConnection? get bluetoothConnection => _bluetoothConnection;

  dispose() async{
    await _bluetoothConnection?.dispose();
  }


  Future<List<int>> readBytes(List<int> request)async{
    if(connectionType == ConnectionType.bluetooth){
      _bluetoothConnection ??= BluetoothConnection(remoteId: bluetoothSettings.macAddress);
      _bluetoothConnection!.remoteId = bluetoothSettings.macAddress;
       final response = await _bluetoothConnection!.readBytes(request);
       return response;
    }else{
      throw Exception("Needs to be implemented");
    }
  }

}