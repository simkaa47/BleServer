import 'dart:typed_data';

import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';

class ModbusService {
  final List<int> inputBuffer = List.filled(1000, 0);

  Future<void> getIndicationData(Device device) async {
    if (device.connectionType == ConnectionType.bluetooth) {
      var nums = await _readInputRegisters(device: device, startAddr: 2, count: 17);
      String hexString =
          nums.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
      print(hexString);
    } else {
      throw Exception(
        "Modbus service: ethernet interface is not implemented yet",
      );
    }
  }

  Future<List<int>> _readInputRegisters({
    required Device device,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async{
    final request = Uint8List(8);
    request[0] = unitId;
    request[1] = 4;
    final view = ByteData.view(request.buffer);
    view.setUint16(2, startAddr, Endian.big);
    view.setUint16(4, count, Endian.big);
    final crc = calculateCrc16(request, 6);
    view.setUint16(6, crc, Endian.little);


    var responce = await device.readBytes(request);
    



    return request;
  }







  int calculateCrc16(Uint8List data, int length) {
    int crc = 0xFFFF;
    final polynomial = 0xA001; // Обратный полином 0x8005

    for (var i = 0; i < length; i++) {
      crc ^= data[i];
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x0001) != 0) {
          crc >>= 1;
          crc ^= polynomial;
        } else {
          crc >>= 1;
        }
      }
    }

    return crc;
  }
}
