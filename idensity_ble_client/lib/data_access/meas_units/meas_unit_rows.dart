import 'package:drift/drift.dart';

class MeasUnitRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get coeff => real()();
  RealColumn get offset => real()();
  IntColumn get deviceMode => integer()();
  IntColumn get measMode => integer()();
  BoolColumn get userCantDelete => boolean().withDefault(const Constant(false))();
}
