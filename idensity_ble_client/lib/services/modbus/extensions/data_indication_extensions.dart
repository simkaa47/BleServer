import 'package:idensity_ble_client/models/indication/analog_input_indication.dart';
import 'package:idensity_ble_client/models/indication/analog_output_indication.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/indication/meas_result.dart';
import 'package:idensity_ble_client/services/modbus/extensions/common_extensions.dart';

extension DataIndicationArrayExtensions on IndicationData {
  void updateDataFromModbus(List<int> registers) {
    isMeasuringState = registers[0] != 0;
    counters = registers.getFloat(2);
    hv = registers.getFloat(30);
    temperature = registers.getFloat(24) / 10;
    rtc = _getRtcFromRegs(registers, rtc);
    // MeasResults
    for (var i = 0; i < 2; i++) {
      measResults[i] = MeasResult(
        measProcIndex: registers[1 + i * 8],
        isActive: registers[8 + i * 8] != 0,
        currentValue: registers.getFloat(4 + i * 8),
        averageValue: registers.getFloat(6 + i * 8),
      );
    }
    //Analogs
    for (var i = 0; i < 2; i++) {
      analogInputIndications[i] = AnalogInputIndication(
        commState: registers[44 + i * 6 + 1] != 0,
        pwrState: registers[44 + i * 6] != 0,
        adcValue: registers.getFloat(44 + i * 6 + 2).toInt(),
      );
      analogOutputIndications[i] = AnalogOutputIndication(
        commState: registers[32 + i * 6 + 1] != 0,
        pwrState: registers[32 + i * 6] != 0,
        adcValue: registers.getFloat(32 + i * 6 + 2).toInt(),
        dacValue: registers.getFloat(32 + i * 6 + 4).toInt(),
      );
    }
  }

  DateTime _getRtcFromRegs(List<int> registers, DateTime defaultValue) {
    final year = registers[18] + 2000;

    final month = registers[19];
    final day = registers[20];
    final hour = registers[21];
    final minute = registers[22];
    int second = registers[23];

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
