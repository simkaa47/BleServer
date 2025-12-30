import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';

abstract class MeasUnitsRepository {
  Future<void> loadMeasUnits(List<MeasUnit> measUnits);
  Future<void> addMeasUnit(MeasUnit unit);
  Future<List<MeasUnit>> getMeasUnits();
  Future<bool> deleteMeasUnit(MeasUnit unit);
}