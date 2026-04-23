import 'package:idensity_ble_client/models/settings/calibration_type.dart';

class CalibrCurve {
  CalibrationType type = CalibrationType.none;
  final List<double> coefficients = List.filled(6, 0);
}
