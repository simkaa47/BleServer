import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';

extension DeviceSettingsExtensions on DeviceSettings {
  void updateDataFromModbus(List<int> registers) {
    deviceMode = registers[102] == 0 ? DeviceMode.density : DeviceMode.level;
    final offset = 200;

    for (var i = 0; i < DeviceSettings.measProcCount; i++) {
      measProcesses[i].measDuration = registers[offset + 180 * i] / 10;
      measProcesses[i].averagePoints = registers[offset + 180 * i + 1];
      measProcesses[i].diameterPipe = registers[offset + 180 * i + 2] / 10;
      measProcesses[i].isActive = registers[offset + 180 * i + 3] != 0;
      measProcesses[i].calcType = registers[offset + 180 * i + 4];
      measProcesses[i].measType = registers[offset + 180 * i + 5];
    }
  }
}
