import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';

extension DeviceSettingsExtensions on DeviceSettings  {
  void updateDataFromModbus(List<int> registers) {
    deviceMode = registers[102] == 0 ? DeviceMode.density : DeviceMode.level;
  }
}