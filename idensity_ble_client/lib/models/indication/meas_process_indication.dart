import 'package:idensity_ble_client/models/indication/measure_indication.dart';

class MeasProcessIndication {
  final List<MeasureIndication> standIndications = List.generate(2, (i) => MeasureIndication());
  final List<MeasureIndication> singleMeasureIndications = List.generate(10, (i) => MeasureIndication());
}