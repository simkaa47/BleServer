import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/models/settings/meas_process.dart';

class DeviceSettings {
  static const measProcCount = 2;
  DeviceMode deviceMode  = DeviceMode.density;
  final List<MeasProcess> measProcesses = List.generate(measProcCount, (i)=> MeasProcess());
}