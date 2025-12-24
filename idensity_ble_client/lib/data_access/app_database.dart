import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:idensity_ble_client/data_access/DataLogCells/data_log_cells.dart';
import 'package:idensity_ble_client/services/path/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    DataLogCells,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getLocalApplicationDocumentsDirectory();
    final dbFolder = Directory(p.join(dir.path, 'databases'));
    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }

    final file = File(p.join(dbFolder.path, 'idensity.db'));
    return NativeDatabase(file);
  });
}