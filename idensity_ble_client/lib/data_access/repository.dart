import 'dart:developer';
import 'dart:io';
import 'package:idensity_ble_client/services/path/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract class Repository {
 
  final String databaseName = "idensity.db";
Future<Database> getDatabase(String databaseName, String initializeDatabaseCommand) async {
    final Directory appDocumentsDir =  await getLocalApplicationDocumentsDirectory();
    final String path = join(appDocumentsDir.path, databaseName);
    log("Начинаем открывать БД");    
    databaseFactory = databaseFactoryFfi;
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute(initializeDatabaseCommand);
        },
      ),
    );
  }
  
}