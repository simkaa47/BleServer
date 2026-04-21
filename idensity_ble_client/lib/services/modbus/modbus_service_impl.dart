import 'dart:math';
import 'dart:typed_data';

import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/modbus/modbus_commands.dart';
import 'package:idensity_ble_client/models/settings/analog_output_settings.dart';
import 'package:idensity_ble_client/models/settings/calibr_curve.dart';
import 'package:idensity_ble_client/models/settings/counter_settings.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:idensity_ble_client/models/settings/fast_change.dart';
import 'package:idensity_ble_client/models/settings/get_temperature.dart';
import 'package:idensity_ble_client/models/settings/serial_settings.dart';
import 'package:idensity_ble_client/models/settings/single_meas_result.dart';
import 'package:idensity_ble_client/models/settings/stand_settings.dart';
import 'package:idensity_ble_client/models/settings/tcp_settings.dart';
import 'package:idensity_ble_client/services/modbus/extensions/data_indication_extensions.dart';
import 'package:idensity_ble_client/services/modbus/extensions/device_settings_extensions.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';

class ModbusServiceImpl implements ModbusService {
  static const int _maxChunkSize = 100;
  static const int _settingsRegisterCount = 560;
  static const int _indicationRegisterCount = 60;

  static const int _measProcRegisterCnt = 180;
  static const int _standRegisterOffset = 24;
  static const int _standRegisterCnt = 12;
  static const int _singleMeasOffset = 76;
  static const int _singleMeasRegCnt = 8;
  static const int _isCheckedOffset = 156;

  // ---------------------------------------------------------------------------
  // Read operations
  // ---------------------------------------------------------------------------

  @override
  Future<IndicationData> getIndicationData(Connection connection) async {
    if (connection.connectionType != ConnectionType.bluetooth) {
      throw Exception(
        'Modbus service: ethernet interface is not implemented yet',
      );
    }
    final buffer = List.filled(1000, 0);
    await _readInputRegisters(
      connection: connection,
      buffer: buffer,
      startAddr: 0,
      count: _indicationRegisterCount,
    );
    return IndicationData()..updateDataFromModbus(buffer);
  }

  @override
  Future<DeviceSettings> getDeviceSettings(Connection connection) async {
    if (connection.connectionType != ConnectionType.bluetooth) {
      throw Exception(
        'Modbus service: ethernet interface is not implemented yet',
      );
    }
    final buffer = List.filled(1000, 0);
    await _readHoldingRegisters(
      connection: connection,
      buffer: buffer,
      startAddr: 0,
      count: _settingsRegisterCount,
    );
    return DeviceSettings()..updateDataFromModbus(buffer);
  }

  // ---------------------------------------------------------------------------
  // Write operations — meas process
  // ---------------------------------------------------------------------------

  @override
  Future<void> writeDeviceType(int value, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value],
      startAddr: 102,
    );
  }

  @override
  Future<void> writeMeasDuration(
    double value,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [(value * 10).toInt()],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt,
    );
  }

  @override
  Future<void> writeAveragePoints(
    int value,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 1,
    );
  }

  @override
  Future<void> writeFastChanges(
    FastChange fastChange,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [fastChange.isActive ? 1 : 0, fastChange.threshold],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 10,
    );
  }

  @override
  Future<void> writeMeasProcActivity(
    bool activity,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [activity ? 1 : 0],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 3,
    );
  }

  @override
  Future<void> writeMeasDiameter(
    double value,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [(value * 10).toInt()],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 2,
    );
  }

  @override
  Future<void> writeMeasActivity(
    bool value,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value ? 1 : 0],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 3,
    );
  }

  @override
  Future<void> writeCalcType(
    int value,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 4,
    );
  }

  @override
  Future<void> writeMeasType(
    int value,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 5,
    );
  }

  @override
  Future<void> writeDensityLiquid(
    double value,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: _floatToRegisters(value),
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 6,
    );
  }

  @override
  Future<void> writeDensitySolid(
    double value,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: _floatToRegisters(value),
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 8,
    );
  }

  @override
  Future<void> writeMeasProcStandartization(
    StandSettings stand,
    int standIndex,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [
        stand.standDuration * 10,
        stand.lastStandDate.year - 2000,
        stand.lastStandDate.month,
        stand.lastStandDate.day,
        ..._floatToRegisters(stand.result),
        ..._floatToRegisters(stand.halfLifeResult),
      ],
      startAddr:
          200 +
          measProcIndex * _measProcRegisterCnt +
          _standRegisterOffset +
          standIndex * _standRegisterCnt,
    );
  }

  @override
  Future<void> writeMeasProcCalibrCurve(
    CalibrCurve calibrCurve,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [
        calibrCurve.type.index,
        0,
        ...calibrCurve.coefficients.expand((c) => _floatToRegisters(c)),
      ],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 60,
    );
  }

  @override
  Future<void> makeStandartization(
    StandSettings stand,
    int standIndex,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [1],
      startAddr:
          200 +
          measProcIndex * _measProcRegisterCnt +
          _standRegisterOffset +
          standIndex * _standRegisterCnt +
          8,
    );
  }

  @override
  Future<void> makeSingleMeasurement(
    int measIndex,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [1],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + _singleMeasOffset + measIndex * _singleMeasRegCnt + 3,
    );
  }

  @override
  Future<void> writeSingleMeasResult(
    SingleMeasResult result,
    int measIndex,
    int measProcIndex,
    int isCheckedMask,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [
        result.date.year - 2000,
        result.date.month,
        result.date.day,
        0,
        ..._floatToRegisters(result.weak),
        ..._floatToRegisters(result.physValue),
      ],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + _singleMeasOffset + measIndex * _singleMeasRegCnt,
    );
    await _writeHoldingRegisters(
      connection: connection,
      registers: [isCheckedMask],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + _isCheckedOffset,
    );
  }

  @override
  Future<void> writeMeasProcSingleMeasDuration(
    int duration,
    int measProcIndex,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [duration*10],
      startAddr: 200 + measProcIndex * _measProcRegisterCnt + 12,
    );
  }

  // ---------------------------------------------------------------------------
  // Write operations — communication settings
  // ---------------------------------------------------------------------------

  @override
  Future<void> writeModbusId(int value, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value],
      startAddr: 0,
    );
  }

  @override
  Future<void> writeTcpSettings(
    TcpSettings settings,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [
        ...settings.address,
        ...settings.mask,
        ...settings.gateway,
        ...settings.macAddress,
      ],
      startAddr: 48,
    );
  }

  @override
  Future<void> writeSerialSettings(
    SerialSettings settings,
    Connection connection,
  ) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [
        ..._uint32ToRegisters(settings.baudrate),
        settings.mode.index,
      ],
      startAddr: 66,
    );
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
    await _writeHoldingRegisters(
      connection: connection,
      registers: [
        settings.isActive ? 1 : 0,
        settings.mode.index,
        settings.measProcessNum,
        settings.analogOutMeasType.index,
        ..._floatToRegisters(settings.minValue),
        ..._floatToRegisters(settings.maxValue),
        ..._uint32ToRegisters((settings.minCurrent * 1000).toInt()),
        ..._uint32ToRegisters((settings.maxCurrent * 1000).toInt()),
        (settings.testValue * 1000).toInt(),
      ],
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
    await _writeHoldingRegisters(
      connection: connection,
      registers: [
        settings.src.index,
        ..._floatToRegisters(settings.coeffs[0].a),
        ..._floatToRegisters(settings.coeffs[0].b),
        ..._floatToRegisters(settings.coeffs[1].a),
        ..._floatToRegisters(settings.coeffs[1].b),
      ],
      startAddr: 103,
    );
  }

  @override
  Future<void> switchMeasState(bool value, Connection connection) async {
    await _writeHoldingRegisters(
      connection: connection,
      registers: [value ? 1 : 0],
      startAddr: 114,
    );
  }

  // ---------------------------------------------------------------------------
  // Private helpers — float/uint conversions
  // ---------------------------------------------------------------------------

  List<int> _floatToRegisters(double value) {
    final bd = ByteData(4);
    bd.setFloat32(0, value, Endian.little);
    return [bd.getUint16(0, Endian.little), bd.getUint16(2, Endian.little)];
  }

  List<int> _uint32ToRegisters(int value) {
    final bd = ByteData(4);
    bd.setUint32(0, value, Endian.little);
    return [bd.getUint16(0, Endian.little), bd.getUint16(2, Endian.little)];
  }

  // ---------------------------------------------------------------------------
  // Private helpers — Modbus framing
  // ---------------------------------------------------------------------------

  Future<void> _readInputRegisters({
    required Connection connection,
    required List<int> buffer,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async {
    await _readRegistersChunked(
      connection: connection,
      buffer: buffer,
      command: ModbusReadCommands.readInputRegisters,
      startAddr: startAddr,
      count: count,
      unitId: unitId,
    );
  }

  Future<void> _readHoldingRegisters({
    required Connection connection,
    required List<int> buffer,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async {
    await _readRegistersChunked(
      connection: connection,
      buffer: buffer,
      command: ModbusReadCommands.readHoldingRegisters,
      startAddr: startAddr,
      count: count,
      unitId: unitId,
    );
  }

  Future<void> _readRegistersChunked({
    required Connection connection,
    required List<int> buffer,
    required ModbusReadCommands command,
    required int startAddr,
    required int count,
    int unitId = 1,
  }) async {
    final steps = (count + _maxChunkSize - 1) ~/ _maxChunkSize;
    int start = startAddr;
    for (var i = 0; i < steps; i++) {
      final chunkSize = min(_maxChunkSize, count - i * _maxChunkSize);
      await _readRegisters(
        connection: connection,
        buffer: buffer,
        command: command,
        startAddr: start,
        count: chunkSize,
        unitId: unitId,
      );
      start += chunkSize;
    }
  }

  Future<void> _readRegisters({
    required Connection connection,
    required List<int> buffer,
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
    final crc = _calculateCrc16(request, 6);
    view.setUint16(6, crc, Endian.little);

    final response = await connection.readBytes(
      request,
      expectedRespLen: 5 + count * 2,
    );
    if (response.length != count * 2 + 5) {
      throw Exception('Invalid response length');
    }
    if (response[1] != command.code) {
      throw Exception('Invalid command in response');
    }

    final byteList = Uint8List.fromList(response);
    final responseCrc = _calculateCrc16(byteList, response.length - 2);
    final realCrc =
        (response[response.length - 1] << 8) | response[response.length - 2];
    if (realCrc != responseCrc) throw Exception('CRC error in response');

    final byteData = ByteData.sublistView(byteList);
    for (var i = 0; i < count; i++) {
      buffer[startAddr + i] = byteData.getUint16(i * 2 + 3, Endian.big);
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
    final crc = _calculateCrc16(request, 7 + count * 2);
    view.setUint16(7 + count * 2, crc, Endian.little);

    final response = await connection.readBytes(request, expectedRespLen: 8);
    if (response.length != 8) throw Exception('Invalid response length');
    if (response[1] != 16) throw Exception('Write error for modbusId=$unitId');

    final byteList = Uint8List.fromList(response);
    final responseCrc = _calculateCrc16(byteList, response.length - 2);
    final realCrc =
        (response[response.length - 1] << 8) | response[response.length - 2];
    if (realCrc != responseCrc) throw Exception('CRC error in response');
  }

  int _calculateCrc16(Uint8List data, int length) {
    int crc = 0xFFFF;
    const polynomial = 0xA001;
    for (var i = 0; i < length; i++) {
      crc ^= data[i];
      for (var j = 0; j < 8; j++) {
        if ((crc & 0x0001) != 0) {
          crc = (crc >> 1) ^ polynomial;
        } else {
          crc >>= 1;
        }
      }
    }
    return crc;
  }
}
