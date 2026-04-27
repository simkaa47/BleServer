import 'package:drift/drift.dart';
import 'package:idensity_ble_client/data_access/app_database.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';

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

  Future<List<String>> getDeviceNames({DateTime? from, DateTime? to}) async {
    final query = db.selectOnly(db.dataLogCells)
      ..addColumns([db.dataLogCells.deviceName])
      ..groupBy([db.dataLogCells.deviceName]);
    if (from != null) {
      query.where(db.dataLogCells.dt.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where(db.dataLogCells.dt.isSmallerOrEqualValue(to));
    }
    final rows = await query.get();
    return rows.map((row) => row.read(db.dataLogCells.deviceName)!).toList();
  }

  Future<int> deleteOlderThan(DateTime dt) {
    return (db.delete(db.dataLogCells)
      ..where((t) => t.dt.isSmallerThanValue(dt))).go();
  }

  Future<List<DataLogCell>> getHistory({
    required String deviceName,
    required ChartType chartType,
    DateTime? from,
    DateTime? to,
  }) {
    final query =
        db.select(db.dataLogCells)
          ..where(
            (t) =>
                t.deviceName.equals(deviceName) &
                t.chartType.equals(chartType.index),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.dt)]);

    if (from != null) {
      query.where((t) => t.dt.isBiggerOrEqualValue(from));
    }

    if (to != null) {
      query.where((t) => t.dt.isSmallerOrEqualValue(to));
    }

    return query.get();
  }
}
