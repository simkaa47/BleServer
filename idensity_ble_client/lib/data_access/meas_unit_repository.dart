import 'package:idensity_ble_client/data_access/repository.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MeasUnitRepository extends Repository {
   static const String measUnitsTableName = "MeasUnits";
   static const String initializeDatabaseCommand = '''
    CREATE TABLE $measUnitsTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        coeff REAL,
        offset REAL,
        deviceMode INTEGER,
        measMode INTEGER,
        userCantDelete INTEGER
    )
    ''';
   

  Future<void> loadMeasUnits(List<MeasUnit> measUnits) async {
    final db = await getDatabase(measUnitsTableName, initializeDatabaseCommand);

    for (final unit in measUnits) {
      try {
        await db.insert(
          measUnitsTableName,
          unit.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } catch (e) {
        print('Произошла ошибка при вставке: $e');
      }
    }
    await db.close();
  }

  Future<void> addMeasUnit(MeasUnit unit) async {
    final db = await getDatabase(measUnitsTableName, initializeDatabaseCommand);
    await db.insert(
      measUnitsTableName,
      unit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.close();
  }

  Future<List<MeasUnit>> getMeasUnits() async {
    try {
      final db = await getDatabase(measUnitsTableName, initializeDatabaseCommand);
      final List<Map<String, dynamic>> maps = await db.query(
        measUnitsTableName,
      );
      await db.close();
      return List.generate(maps.length, (i) {
        return MeasUnit.fromMap(maps[i]);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteMeasUnit(MeasUnit unit) async {
    if (unit.id == null) return false;
    final db = await getDatabase(measUnitsTableName, initializeDatabaseCommand);
    await db.delete(
      measUnitsTableName,
      // Используем 'where' для указания условия удаления
      where: 'id = ?',
      // Передаем значение id в качестве аргумента, чтобы предотвратить SQL-инъекции
      whereArgs: [unit.id],
    );
    await db.close();
    return true;
  }
}
