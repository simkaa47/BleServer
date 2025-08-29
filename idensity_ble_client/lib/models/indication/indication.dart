import 'package:idensity_ble_client/models/indication/analog_input_indication.dart';
import 'package:idensity_ble_client/models/indication/analog_output_indication.dart';
import 'package:idensity_ble_client/models/indication/meas_result.dart';

class IndicationData {
  double temperature = 0;
  double hv = 0;
  double counters = 0;
  final List<MeasResult> measResults = List.generate(
    2,
    (i) => MeasResult(
      measProcIndex: 0,
      isActive: false,
      currentValue: 0,
      averageValue: 0,
    ),
  );

  final List<AnalogInputIndication> analogInputIndications = List.generate(
    2,
    (i) =>
        AnalogInputIndication(adcValue: 0, commState: false, pwrState: false),
  );

  final List<AnalogOutputIndication> analogOutputIndications = List.generate(
    2,
    (i) => AnalogOutputIndication(
      adcValue: 0,
      commState: false,
      dacValue: 0,
      pwrState: false,
    ),
  );
}
