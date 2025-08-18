import 'package:idensity_ble_client/models/indication/analog_indication.dart';

class AnalogOutputIndication extends AnalogIndication {
  final int dacValue;
  double get current => 0.00735 * dacValue;

  AnalogOutputIndication({
    required super.commState,
    required super.pwrState,
    required super.adcValue,
    required this.dacValue,
  });
}
