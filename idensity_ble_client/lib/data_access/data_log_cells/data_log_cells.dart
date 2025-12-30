import 'package:drift/drift.dart';

@TableIndex(name: 'idx_device_type_dt', columns: {#deviceName, #chartType, #dt})
class DataLogCells extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceName => text().withLength(min: 1, max: 20)();
  IntColumn get chartType => integer()();
  DateTimeColumn get dt => dateTime()();
  RealColumn get value => real()();

 
}
