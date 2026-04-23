import 'package:idensity_ble_client/models/settings/analog_out_meas_type.dart';
import 'package:idensity_ble_client/models/settings/analog_output_mode.dart';

class AnalogOutputSettings {
  bool isActive = false;
  AnalogOutputMode mode = AnalogOutputMode.measuredValue;
  int measProcessNum = 0;
  AnalogOutMeasType analogOutMeasType = AnalogOutMeasType.currentValue;
  double minValue = 0;
  double maxValue = 0;
  double minCurrent = 4;
  double maxCurrent = 20;
  double testValue = 0;
}
