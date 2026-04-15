import 'dart:math';
import 'dart:typed_data';

import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/modbus/modbus_commands.dart';
import 'package:idensity_ble_client/models/settings/analog_output_settings.dart';
import 'package:idensity_ble_client/models/settings/counter_settings.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:idensity_ble_client/models/settings/get_temperature.dart';
import 'package:idensity_ble_client/models/settings/serial_settings.dart';
import 'package:idensity_ble_client/models/settings/tcp_settings.dart';
import 'package:idensity_ble_client/services/modbus/extensions/data_indication_extensions.dart';
import 'package:idensity_ble_client/services/modbus/extensions/device_settings_extensions.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';

class ModbusServiceImpl implements ModbusService {
  static const int maxRegisterSize = 100;

  // How many holding registers to read for full device settings.
  // MeasProcess[1] single meas results end at 380+76+10*8 = 536, round up.
  static const int _settingsRegisterCount = 560;

  final List<int> inputBuffer = List.filled(1000, 0);

  // ---------------------------------------------------------------------------
  // Read operations
  // ---------------------------------------------------------------------------

  @override
  Future<IndicationData> getIndicationData(Connection connection) async {
    if (connection.connectionSettings.connectionType == ConnectionType.bluetooth) {
      await _readInputRegisters(connection: connection, startAddr: 0, count: 60);
      final data = IndicationData();
      data.updateDataFromModbus(inputBuffer);
      return data;
    } else {
      throw Exception('Modbus service: ethernet interface is not implemented yet');
    }
  }

  @override
  Future<DeviceSettings> getDeviceSettings(Connection connection) async {
    if (connection.connectionSettings.connectionType == ConnectionType.bluetooth) {
      await _readHoldingRegisters(
        connection: connection,
        startAddr: 0,
        count: _settingsRegisterCount,
      );
      final settings = DeviceSettings();
      settings.updateDataFromModbus(inputBuffer);
      return settings;
    } else {
      throw Exception('Modbus service: ethernet interface is not implemented yet');
    }
  }

  // ---------------------------------------------------------------------------
  // Write operations — meas process
  // ---------------------------------------------------------------------------

  @override
  Future<void> writeDeviceType(int value, Connection connection) async {
    await _writeHoldingRegisters(connection: connection, registers: [value], startAddr: 102);
  }

  @override
  Future<void> writeMeasDuration(double value, int measProcIndex, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [(value * 10).toInt()],
      startAddr: 200 + measProcIndex * 180,
    );
  }

  @override
  Future<void> writeAveragePoints(int value, int measProcIndex, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value],
      startAddr: 200 + measProcIndex * 180 + 1,
    );
  }

  @override
  Future<void> writeMeasDiameter(double value, int measProcIndex, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [(value * 10).toInt()],
      startAddr: 200 + measProcIndex * 180 + 2,
    );
  }

  @override
  Future<void> writeMeasActivity(bool value, int measProcIndex, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value ? 1 : 0],
      startAddr: 200 + measProcIndex * 180 + 3,
    );
  }

  @override
  Future<void> writeCalcType(int value, int measProcIndex, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value],
      startAddr: 200 + measProcIndex * 180 + 4,
    );
  }

  @override
  Future<void> writeMeasType(int value, int measProcIndex, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value],
      startAddr: 200 + measProcIndex * 180 + 5,
    );
  }

  @override
  Future<void> writeDensityLiquid(double value, int measProcIndex, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: _floatToRegisters(value),
      startAddr: 200 + measProcIndex * 180 + 6,
    );
  }

  @override
  Future<void> writeDensitySolid(double value, int measProcIndex, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: _floatToRegisters(value),
      startAddr: 200 + measProcIndex * 180 + 8,
    );
  }

  // ---------------------------------------------------------------------------
  // Write operations — communication settings
  // ---------------------------------------------------------------------------

  @override
  Future<void> writeModbusId(int value, Connection connection) async {
    await _writeHoldingRegisters(connection: connection, registers: [value], startAddr: 0);
  }

  @override
  Future<void> writeTcpSettings(TcpSettings settings, Connection connection) async {
    final registers = [
      ...settings.address,
      ...settings.mask,
      ...settings.gateway,
      ...settings.macAddress,
    ];
    await _writeHoldingRegisters(connection: connection, registers: registers, startAddr: 48);
  }

  @override
  Future<void> writeSerialSettings(SerialSettings settings, Connection connection) async {
    final registers = [
      ..._uint32ToRegisters(settings.baudrate),
      settings.mode.index,
    ];
    await _writeHoldingRegisters(connection: connection, registers: registers, startAddr: 66);
  }

  // ---------------------------------------------------------------------------
  // Write operations — counter settings
  // ---------------------------------------------------------------------------

  @override
  Future<void> writeCounterSettings(
    CounterSettings settings,
    int counterIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [settings.start, settings.width, settings.mode.index],
      startAddr: 24 + counterIndex * 8,
    );
  }

  // ---------------------------------------------------------------------------
  // Write operations — analog output settings
  // ---------------------------------------------------------------------------

  @override
  Future<void> writeAnalogOutputSettings(
    AnalogOutputSettings settings,
    int outputIndex,
    Connection connection,
  ) async {
    final registers = [
      settings.isActive ? 1 : 0,
      settings.mode.index,
      settings.measProcessNum,
      settings.analogOutMeasType.index,
      ..._floatToRegisters(settings.minValue),
      ..._floatToRegisters(settings.maxValue),
      ..._uint32ToRegisters((settings.minCurrent * 1000).toInt()),
      ..._uint32ToRegisters((settings.maxCurrent * 1000).toInt()),
      (settings.testValue * 1000).toInt(),
    ];
    await _writeHoldingRegisters(
      connection: connection,
      registers: registers,
      startAddr: 74 + outputIndex * 14,
    );
  }

  // ---------------------------------------------------------------------------
  // Write operations — temperature compensation
  // ---------------------------------------------------------------------------

  @override
  Future<void> writeTemperatureCompensation(
    GetTemperature settings,
    Connection connection,
  ) async {
    final registers = [
      settings.src.index,
      ..._floatToRegisters(settings.coeffs[0].a),
      ..._floatToRegisters(settings.coeffs[0].b),
      ..._floatToRegisters(settings.coeffs[1].a),
      ..._floatToRegisters(settings.coeffs[1].b),
    ];
    await _writeHoldingRegisters(connection: connection, registers: registers, startAddr: 103);
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Splits a 32-bit float into two 16-bit registers (little-endian word order).
  List<int> _floatToRegisters(double value) {
    final bd = ByteData(4);
    bd.setFloat32(0, value, Endian.little);
    return [bd.getUint16(0, Endian.little), bd.getUint16(2, Endian.little)];
  }

  /// Splits a 32-bit unsigned int into two 16-bit registers (little-endian word order).
  List<int> _uint32ToRegisters(int value) {
    final bd = ByteData(4);
    bd.setUint32(0, value, Endian.little);
    return [bd.getUint16(0, Endian.little), bd.getUint16(2, Endian.little)];
  }

  Future<void> _readInputRegisters({
    required Connection connection,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async {
    await _readRegsitersCommon(
      connection: connection,
      command: ModbusReadCommands.readInputRegisters,
      startAddr: startAddr,
      count: count,
      unitId: unitId,
    );
  }

  Future<void> _readHoldingRegisters({
    required Connection connection,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async {
    await _readRegsitersCommon(
      connection: connection,
      command: ModbusReadCommands.readHoldingRegisters,
      startAddr: startAddr,
      count: count,
      unitId: unitId,
    );
  }

  Future<void> _readRegisters({
    required Connection connection,
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

    var responce = await connection.readBytes(request, expectedRespLen: 5 + count * 2);
    if (responce.length != (count * 2 + 5)) {
      throw Exception('Invalid response length');
    }
    if (responce[1] != command.code) {
      throw Exception('invalid request');
    }
    final byteList = Uint8List.fromList(responce);
    var responceCrc = calculateCrc16(byteList, responce.length - 2);
    var realCrc = (responce[responce.length - 1] << 8) | responce[responce.length - 2];
    if (realCrc != responceCrc) {
      throw Exception('Crc responce err');
    }
    final ByteData byteData = ByteData.sublistView(byteList);
    final end = startAddr + count;
    for (var i = startAddr; i < end; i++) {
      inputBuffer[i] = byteData.getUint16((i - startAddr) * 2 + 3, Endian.big);
    }
  }

  Future<void> _writeHoldingRegisters({
    required Connection connection,
    required List<int> registers,
    required int startAddr,
    int unitId = 1,
  }) async {
    final count = registers.length;
    final request = Uint8List(9 + count * 2);
    request[0] = unitId;
    request[1] = 16;
    final view = ByteData.view(request.buffer);
    view.setUint16(2, startAddr, Endian.big);
    view.setUint16(4, count, Endian.big);
    request[6] = count * 2;
    for (var i = 0; i < count; i++) {
      view.setUint16(7 + i * 2, registers[i], Endian.big);
    }
    final crc = calculateCrc16(request, 7 + count * 2);
    view.setUint16(7 + count * 2, crc, Endian.little);

    var responce = await connection.readBytes(request, expectedRespLen: 8);
    if (responce.length != 8) throw Exception('Invalid response length');
    if (responce[1] != 16) {
      throw Exception('Write error for modbusId = $unitId');
    }
    final byteList = Uint8List.fromList(responce);
    var responceCrc = calculateCrc16(byteList, responce.length - 2);
    var realCrc = (responce[responce.length - 1] << 8) | responce[responce.length - 2];
    if (realCrc != responceCrc) {
      throw Exception('Crc responce err');
    }
  }

  int calculateCrc16(Uint8List data, int length) {
    int crc = 0xFFFF;
    const polynomial = 0xA001;
    for (var i = 0; i < length; i++) {
      crc ^= data[i];
      for (int j = 0; j < 8; j++) {
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

  Future<void> _readRegsitersCommon({
    required Connection connection,
    required ModbusReadCommands command,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async {
    final steps = (count % maxRegisterSize == 0
            ? count ~/ maxRegisterSize
            : count ~/ maxRegisterSize + 1);
    int start = startAddr;
    for (var i = 0; i < steps; i++) {
      int tmpCnt = min(maxRegisterSize, count - (i * maxRegisterSize));
      await _readRegisters(
        connection: connection,
        command: command,
        startAddr: start,
        count: tmpCnt,
        unitId: unitId,
      );
      start += tmpCnt;
    }
  }
}
