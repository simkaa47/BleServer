import 'package:idensity_ble_client/data_access/repository.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MeasUnitRepository extends Repository {
  Future<Database> _openDatabase() async {
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
    CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        name TEXT,
        coeff REAL,
        offset REAL,
        deviceMode INTEGER,
        measMode INTEGER,
        userCantDelete INTEGER
    )
    ''');
        },
      ),
    );
  }

  final String tableName = "MeasUnits";
  Future<void> loadMeasUnits(List<MeasUnit> measUnits) async {
    final db = await _openDatabase();

    for (final unit in measUnits) {
      await db.insert(
        'MeasUnit',
        unit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await db.close();
  }

  Future<List<MeasUnit>> getMeasUnits() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    await db.close();
    return List.generate(maps.length, (i) {
      return MeasUnit.fromMap(maps[i]);
    });
  }
}
