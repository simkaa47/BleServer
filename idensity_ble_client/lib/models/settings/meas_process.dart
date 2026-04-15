import 'package:idensity_ble_client/models/settings/calibr_curve.dart';
import 'package:idensity_ble_client/models/settings/fast_change.dart';
import 'package:idensity_ble_client/models/settings/single_meas_result.dart';
import 'package:idensity_ble_client/models/settings/stand_settings.dart';

class MeasProcess {
  double measDuration = 0;
  double diameterPipe = 0;
  int averagePoints = 0;
  int calcType = 0;
  int measType = 0;
  bool isActive = false;
  double densityLiquid = 0;
  double densitySolid = 0;
  final FastChange fastChange = FastChange();
  int singleMeasTime = 0;
  final List<StandSettings> standSettings = List.generate(3, (_) => StandSettings());
  final CalibrCurve calibrCurve = CalibrCurve();
  final List<SingleMeasResult> singleMeasResults = List.generate(10, (_) => SingleMeasResult());
}
