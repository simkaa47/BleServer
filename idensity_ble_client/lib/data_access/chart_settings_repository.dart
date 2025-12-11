import 'package:idensity_ble_client/data_access/repository.dart';

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

    
}