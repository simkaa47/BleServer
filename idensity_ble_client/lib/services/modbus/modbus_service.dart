import 'dart:typed_data';

import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/modbus/modbus_commands.dart';

class ModbusService {
  final List<int> inputBuffer = List.filled(1000, 0);

  Future<void> getIndicationData(Device device) async {
    if (device.connectionType == ConnectionType.bluetooth) {
      await _readInputRegisters(
        device: device,
        startAddr: 0,
        count: 75,
      );    
      await _readInputRegisters(
        device: device,
        startAddr: 75,
        count: 50,
      );            
    } else {
      throw Exception(
        "Modbus service: ethernet interface is not implemented yet",
      );
    }
  }

  Future<void> _readInputRegisters({
    required Device device,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async {
    await _readRegisters(
      device: device,
      command: ModbusReadCommands.readInputRegisters,
      startAddr: startAddr,
      count: count,
      unitId: unitId,
    );
  }

  Future<void> _readHoldingRegisters({
    required Device device,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async {
    await _readRegisters(
      device: device,
      command: ModbusReadCommands.readHoldingRegisters,
      startAddr: startAddr,
      count: count,
      unitId: unitId,
    );
  }

  Future<void> _readRegisters({
    required Device device,
    required ModbusReadCommands command,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async {
    final request = Uint8List(8);
    request[0] = unitId;
    request[1] = command.code;
    final view = ByteData.view(request.buffer);
    view.setUint16(2, startAddr, Endian.big);
    view.setUint16(4, count, Endian.big);
    final crc = calculateCrc16(request, 6);
    view.setUint16(6, crc, Endian.little);

    var responce = await device.readBytes(request);
    if (responce.length != (count * 2 + 5)) {
      throw Exception("Invalid response length");
    }
    if (responce[1] != command.code) {
      throw Exception("invalid request");
    }
    final byteList = Uint8List.fromList(responce);
    var responceCrc = calculateCrc16(byteList, responce.length - 2);
    var realCrc =
        (responce[responce.length - 1] << 8) | responce[responce.length - 2];
    if (realCrc != responceCrc) {
      throw Exception("Crc responce err");
    }
    final ByteData byteData = ByteData.sublistView(byteList);    
    final end = startAddr + count;
    for (var i = startAddr; i < end; i++) {
      inputBuffer[i] = byteData.getUint16((i -startAddr) * 2 + 3, Endian.big);
    }    
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
