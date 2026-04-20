import 'dart:math';

import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/settings/adc_board_settings.dart';
import 'package:idensity_ble_client/models/settings/analog_output_settings.dart';
import 'package:idensity_ble_client/models/settings/counter_settings.dart';
import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/models/settings/get_temperature.dart';
import 'package:idensity_ble_client/models/settings/meas_process.dart';
import 'package:idensity_ble_client/models/settings/serial_settings.dart';
import 'package:idensity_ble_client/models/settings/tcp_settings.dart';

class DeviceSettings {
  DeviceMode deviceMode = DeviceMode.density;
  int modbusId = 1;
  String deviceName = '';
  double levelLength = 0;
  final List<MeasProcess> measProcesses = List.generate(min(2, Device.measProcCnt), (i) => MeasProcess());
  final List<CounterSettings> counterSettings = List.generate(3, (_) => CounterSettings());
  final TcpSettings ethernetSettings = TcpSettings();
  final SerialSettings serialSettings = SerialSettings();
  final AdcBoardSettings adcBoardSettings = AdcBoardSettings();
  final List<bool> analogInputActivities = List.filled(2, false);
  final List<AnalogOutputSettings> analogOutputSettings = List.generate(2, (_) => AnalogOutputSettings());
  final GetTemperature getTemperature = GetTemperature();
}
