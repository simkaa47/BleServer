import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';

abstract interface class MeasUnitService {
  List<MeasUnit> get measUnits;
  Stream<List<MeasUnit>> get measUnitsStream;
  Stream<Map<String, int>> get measUnitSelectingStream;

  Future<void> init();
  Future<void> addMeasUnit(MeasUnit measUnit);
  Future<void> editMeasUnit(MeasUnit measUnit);
  Future<bool> deleteMeasUnit(MeasUnit measUnit);
  Future<void> changeMeasUnit(MeasUnit unit);

  List<MeasUnit> getMeasUnitsForMeasProc(int measMode, int deviceMode);
  MeasUnit? getMeasUnitForMeasProc(int measMode, int deviceMode);

  void dispose();
}
