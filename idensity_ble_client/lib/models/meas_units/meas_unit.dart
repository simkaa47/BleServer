import 'package:idensity_ble_client/models/settings/device_mode.dart';

class MeasUnit {
  int? id;
  String name = "";
  double coeff = 0;
  double offset = 0;
  DeviceMode deviceMode = DeviceMode.density;
  int measMode = 0;
  bool userCantDelete = false;

  MeasUnit({
    this.id,
    required this.name,
    required this.coeff,
    required this.offset,
    required this.deviceMode,
    required this.measMode,
    required this.userCantDelete,
  });

  MeasUnit.withDefaults()
    : this(
        name: "",
        coeff: 0,
        deviceMode: DeviceMode.density,
        measMode: 0,
        offset: 0,
        userCantDelete: false,
      );     
}
