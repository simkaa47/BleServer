import 'package:drift/drift.dart';

class CommonSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get maxChartWindowSec =>
      integer().withDefault(const Constant(60))();
  BoolColumn get darkMode => boolean().withDefault(const Constant(false))();
}
