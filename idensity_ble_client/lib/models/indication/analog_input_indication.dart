import 'package:idensity_ble_client/models/indication/analog_indication.dart';

class AnalogInputIndication extends AnalogIndication {
  AnalogInputIndication({
    required super.commState,
    required super.pwrState,
    required super.adcValue,
  });

  double get current => adcValue * 0.001;
}
