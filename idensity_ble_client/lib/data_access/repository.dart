import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class Repository {
  final String measUnitsTableName = "MeasUnits";
  final String databaseName = "idensity.db";
Future<Database> getDatabase() async {
    Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final String path = join(appDocumentsDir.path, databaseName);
    print("Начинаем открывать БД");    
    databaseFactory = databaseFactoryFfi;
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          print("On crerate db");
          await db.execute('''
    CREATE TABLE $measUnitsTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
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
  
}