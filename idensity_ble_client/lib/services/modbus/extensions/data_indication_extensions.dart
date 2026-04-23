import 'package:idensity_ble_client/models/indication/analog_input_indication.dart';
import 'package:idensity_ble_client/models/indication/analog_output_indication.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/indication/meas_result.dart';
import 'package:idensity_ble_client/services/modbus/extensions/common_extensions.dart';

extension DataIndicationArrayExtensions on IndicationData {
  void updateDataFromModbus(List<int> registers) {
    // IsMeasuringState (reg 0)
    isMeasuringState = registers[0] != 0;

    // MeasResults (reg 1..16, step 8 per result)
    for (var i = 0; i < 2; i++) {
      measResults[i] = MeasResult(
        measProcIndex: registers[1 + i * 8],
        counterValue: registers.getFloat(2 + i * 8),
        currentValue: registers.getFloat(4 + i * 8),
        averageValue: registers.getFloat(6 + i * 8),
        isActive: registers[8 + i * 8] != 0,
      );
    }

    // Communication states bitmask (reg 17)
    final commStates = registers[17];
    adcBoardConnectState = (commStates & 0x0001) == 0;
    tempBoardTelemetry.boardConnectingState = (commStates & 0x0002) == 0;
    hvBoardTelemetry.boardConnectingState = (commStates & 0x0004) == 0;

    // RTC (reg 18..23)
    rtc = _getRtcFromRegs(registers, rtc);

    // TempBoard telemetry (reg 24..25, float / 10)
    tempBoardTelemetry.temperature = registers.getFloat(24) / 10;

    // HV board telemetry (reg 28..31)
    hvBoardTelemetry.inputVoltage = registers.getFloat(28);
    hvBoardTelemetry.outputVoltage = registers.getFloat(30);

    // Analog outputs (reg 32..43, step 6)
    for (var i = 0; i < 2; i++) {
      analogOutputIndications[i] = AnalogOutputIndication(
        pwrState: registers[32 + i * 6] != 0,
        commState: registers[33 + i * 6] != 0,
        adcValue: registers.getFloat(34 + i * 6).toInt(),
        dacValue: registers.getFloat(36 + i * 6).toInt(),
      );
    }

    // Analog inputs (reg 44..55, step 6)
    for (var i = 0; i < 2; i++) {
      analogInputIndications[i] = AnalogInputIndication(
        pwrState: registers[44 + i * 6] != 0,
        commState: registers[45 + i * 6] != 0,
        adcValue: registers.getFloat(46 + i * 6).toInt(),
      );
    }
  }

  DateTime _getRtcFromRegs(List<int> registers, DateTime defaultValue) {
    final year = registers[18] + 2000;
    final month = registers[19];
    final day = registers[20];
    final hour = registers[21];
    final minute = registers[22];
    final second = registers[23];

    if (month < 1 ||
        month > 12 ||
        day < 1 ||
        day > 31 ||
        hour > 23 ||
        minute > 59 ||
        second > 59) {
      return defaultValue;
    }
    return DateTime(year, month, day, hour, minute, second);
  }
}
