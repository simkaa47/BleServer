import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/settings/adc_board_mode.dart';
import 'package:idensity_ble_client/models/settings/analog_out_meas_type.dart';
import 'package:idensity_ble_client/models/settings/analog_output_mode.dart';
import 'package:idensity_ble_client/models/settings/calibration_type.dart';
import 'package:idensity_ble_client/models/settings/counter_mode.dart';
import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:idensity_ble_client/models/settings/get_temperature_src.dart';
import 'package:idensity_ble_client/models/settings/serial_port_mode.dart';
import 'package:idensity_ble_client/services/modbus/extensions/common_extensions.dart';

extension DeviceSettingsExtensions on DeviceSettings {
  void updateDataFromModbus(List<int> registers) {
    // ModbusId (reg 0)
    modbusId = registers[0];

    // AdcBoardSettings (reg 3..13, 20)
    adcBoardSettings.mode = AdcBoardMode.values[registers[3].clamp(0, AdcBoardMode.values.length - 1)];
    adcBoardSettings.syncLevel = registers[4];
    adcBoardSettings.timerSendData = registers[5];
    adcBoardSettings.gain = registers[6];
    for (var i = 0; i < 4; i++) {
      adcBoardSettings.updAddress[i] = registers[7 + i];
    }
    adcBoardSettings.udpPort = registers[11];
    adcBoardSettings.hvSv = registers[12] ~/ 20;
    adcBoardSettings.peakSpectrumSv = registers[13];
    adcBoardSettings.adcDataSendEnabled = registers[20] != 0;

    // CounterSettings (reg 24..47, step 8)
    for (var i = 0; i < 3; i++) {
      counterSettings[i].start = registers[24 + i * 8];
      counterSettings[i].width = registers[24 + i * 8 + 1];
      counterSettings[i].mode = CounterMode.values[registers[24 + i * 8 + 2].clamp(0, CounterMode.values.length - 1)];
    }

    // EthernetSettings (reg 48..65)
    for (var i = 0; i < 4; i++) {
      ethernetSettings.address[i] = registers[48 + i];
      ethernetSettings.mask[i] = registers[48 + 4 + i];
      ethernetSettings.gateway[i] = registers[48 + 8 + i];
    }
    for (var i = 0; i < 6; i++) {
      ethernetSettings.macAddress[i] = registers[48 + 12 + i];
    }

    // SerialSettings (reg 66..68)
    serialSettings.baudrate = registers.getUint32(66);
    serialSettings.mode = SerialPortMode.values[registers[68].clamp(0, SerialPortMode.values.length - 1)];

    // AnalogInputActivities (reg 70..71)
    analogInputActivities[0] = registers[70] != 0;
    analogInputActivities[1] = registers[71] != 0;

    // AnalogOutputSettings (reg 74..101, step 14)
    for (var i = 0; i < 2; i++) {
      final base = 74 + i * 14;
      analogOutputSettings[i].isActive = registers[base] != 0;
      analogOutputSettings[i].mode = AnalogOutputMode.values[registers[base + 1].clamp(0, AnalogOutputMode.values.length - 1)];
      analogOutputSettings[i].measProcessNum = registers[base + 2];
      analogOutputSettings[i].analogOutMeasType = AnalogOutMeasType.values[registers[base + 3].clamp(0, AnalogOutMeasType.values.length - 1)];
      analogOutputSettings[i].minValue = registers.getFloat(base + 4);
      analogOutputSettings[i].maxValue = registers.getFloat(base + 6);
      analogOutputSettings[i].minCurrent = registers.getUint32(base + 8) / 1000;
      analogOutputSettings[i].maxCurrent = registers.getUint32(base + 10) / 1000;
      analogOutputSettings[i].testValue = registers[base + 12] / 1000;
    }

    // DeviceType (reg 102)
    deviceMode = registers[102] == 0 ? DeviceMode.density : DeviceMode.level;

    // GetTemperature (reg 103..111)
    getTemperature.src = GetTemperatureSrc.values[registers[103].clamp(0, GetTemperatureSrc.values.length - 1)];
    for (var i = 0; i < 2; i++) {
      getTemperature.coeffs[i].a = registers.getFloat(104 + i * 4);
      getTemperature.coeffs[i].b = registers.getFloat(106 + i * 4);
    }

    // LevelLength (reg 112..113, float)
    levelLength = registers.getFloat(112);

    // DeviceName (reg 124..128, 5 registers = 10 ASCII bytes)
    final nameBytes = <int>[];
    for (var i = 124; i < 129; i++) {
      final reg = registers[i];
      nameBytes.add(reg & 0xFF);
      nameBytes.add((reg >> 8) & 0xFF);
    }
    deviceName = String.fromCharCodes(nameBytes.where((b) => b != 0));

    // MeasProcesses (reg 200+, step 180)
    const mpOffset = 200;
    const mpStep = 180;
    const standRegOffset = 24;
    const standRegCnt = 12;
    const standCnt = 3;
    const singleMeasOffset = 76;
    const singleMeasRegCnt = 8;
    const singleMeasCnt = 10;

    for (var i = 0; i < Device.measProcCnt; i++) {
      final base = mpOffset + mpStep * i;
      measProcesses[i].measDuration = registers[base] / 10;
      measProcesses[i].averagePoints = registers[base + 1];
      measProcesses[i].diameterPipe = registers[base + 2] / 10;
      measProcesses[i].isActive = registers[base + 3] != 0;
      measProcesses[i].calcType = registers[base + 4];
      measProcesses[i].measType = registers[base + 5];
      measProcesses[i].densityLiquid = registers.getFloat(base + 6);
      measProcesses[i].densitySolid = registers.getFloat(base + 8);
      measProcesses[i].fastChange.isActive = registers[base + 10] != 0;
      measProcesses[i].fastChange.threshold = registers[base + 11];
      measProcesses[i].singleMeasTime = registers[base + 12] ~/ 10;

      // StandSettings (base + 24, step 12)
      for (var s = 0; s < standCnt; s++) {
        final sb = base + standRegOffset + s * standRegCnt;
        measProcesses[i].standSettings[s].standDuration = registers[sb] ~/ 10;
        final year = registers[sb + 1] + 2000;
        int month = registers[sb + 2];
        month = (month >= 1 && month <= 12) ? month : 1;
        int day = registers[sb + 3];
        day = (day >= 1 && day <= 31) ? day : 1;
        measProcesses[i].standSettings[s].lastStandDate = DateTime(year, month, day);
        measProcesses[i].standSettings[s].result = registers.getFloat(sb + 4);
        measProcesses[i].standSettings[s].halfLifeResult = registers.getFloat(sb + 6);
      }

      // CalibrCurve (base + 60)
      measProcesses[i].calibrCurve.type = CalibrationType.values[registers[base + 60].clamp(0, CalibrationType.values.length - 1)];
      for (var c = 0; c < 6; c++) {
        measProcesses[i].calibrCurve.coefficients[c] = registers.getFloat(base + 62 + c * 2);
      }

      // SingleMeasResults (base + 76, step 8)
      for (var m = 0; m < singleMeasCnt; m++) {
        final mb = base + singleMeasOffset + m * singleMeasRegCnt;
        final year = registers[mb] + 2000;
        int month = registers[mb + 1];
        month = (month >= 1 && month <= 12) ? month : 1;
        int day = registers[mb + 2];
        day = (day >= 1 && day <= 31) ? day : 1;
        measProcesses[i].singleMeasResults[m].date = DateTime(year, month, day);
        measProcesses[i].singleMeasResults[m].weak = registers.getFloat(mb + 4);
        measProcesses[i].singleMeasResults[m].physValue = registers.getFloat(mb + 6);
      }
    }
  }
}
