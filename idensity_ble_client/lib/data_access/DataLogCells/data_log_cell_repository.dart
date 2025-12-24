import 'package:drift/drift.dart';
import 'package:idensity_ble_client/data_access/app_database.dart';

class DataLogCellRepository {
  final AppDatabase db;

  DataLogCellRepository({required this.db});

  Future<int> insert(DataLogCellsCompanion cell) {
    return db.into(db.dataLogCells).insert(cell);
  }

  Future<void> insertBatch(List<DataLogCellsCompanion> cells) async {
    await db.batch((batch) {
      batch.insertAll(db.dataLogCells, cells);
    });
  }

  Stream<List<DataLogCell>> watchByDeviceAndType({
    required String deviceName,
    required int chartType,
  }) {
    return (db.select(db.dataLogCells)
          ..where(
            (t) =>
                t.deviceName.equals(deviceName) & t.chartType.equals(chartType),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.dt)]))
        .watch();
  }

  Future<int> deleteOlderThan(DateTime dt) {
    return (db.delete(db.dataLogCells)
      ..where((t) => t.dt.isSmallerThanValue(dt))).go();
  }
}
