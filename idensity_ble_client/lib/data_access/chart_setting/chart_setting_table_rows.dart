import 'package:drift/drift.dart';

class ChartSettingTableRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get color => text()();
  TextColumn get deviceName => text()();
  IntColumn get chartType => integer()();
  BoolColumn get rightAxis => boolean().withDefault(const Constant(false))();
}
