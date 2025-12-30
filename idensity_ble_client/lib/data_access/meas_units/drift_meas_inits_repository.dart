import 'package:idensity_ble_client/data_access/app_database.dart';
import 'package:idensity_ble_client/data_access/meas_units/meas_units_extensions.dart';
import 'package:idensity_ble_client/data_access/meas_units/meas_units_repository.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';

class DriftMeasInitsRepository implements MeasUnitsRepository {
  final AppDatabase db;
  DriftMeasInitsRepository(this.db);

  @override
  Future<void> loadMeasUnits(List<MeasUnit> measUnits) async {
    await db.batch((batch) {
      batch.deleteAll(db.measUnitRows);

      batch.insertAll(
        db.measUnitRows,
        measUnits.map((e) => e.toCompanion()).toList(),
      );
    });
  }

  @override
  Future<void> addMeasUnit(MeasUnit unit) async {
    await db.into(db.measUnitRows).insertOnConflictUpdate(unit.toCompanion());
  }

  @override
  Future<List<MeasUnit>> getMeasUnits() async {
    final rows = await db.select(db.measUnitRows).get();
    return rows.map((e) => e.toModel()).toList();
  }

  @override
  Future<bool> deleteMeasUnit(MeasUnit unit) async {
    if (unit.userCantDelete || unit.id == null) {
      return false;
    }

    final deleted = await (db.delete(db.measUnitRows)
          ..where((t) => t.id.equals(unit.id!)))
        .go();

    return deleted > 0;
  }
}