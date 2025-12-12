import 'package:idensity_ble_client/data_access/repository.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ChartSettingsRepository extends Repository {
  static const String tableName = "ChartSettings";
  static const String initializeDatabaseCommand = '''
    CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rightAxis INTEGER,
        color TEXT,
        deviceName TEXT,
        chartType INTEGER
    )
    ''';

  Future<List<ChartSettings>> getSettings() async {
    try {
      final db = await getDatabase(tableName, initializeDatabaseCommand);
      final List<Map<String, dynamic>> maps = await db.query(tableName);
      await db.close();
      return List.generate(maps.length, (i) {
        return ChartSettings.fromMap(maps[i]);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> add(ChartSettings settings) async {
    final db = await getDatabase(tableName, initializeDatabaseCommand);
    await db.insert(
      tableName,
      settings.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.close();
  }

  Future<bool> delete(ChartSettings settings) async {
    if (settings.id == null) return false;
    final db = await getDatabase(tableName, initializeDatabaseCommand);
    await db.delete(
      tableName,
      // Используем 'where' для указания условия удаления
      where: 'id = ?',
      // Передаем значение id в качестве аргумента, чтобы предотвратить SQL-инъекции
      whereArgs: [settings.id],
    );
    await db.close();
    return true;
  }

}
