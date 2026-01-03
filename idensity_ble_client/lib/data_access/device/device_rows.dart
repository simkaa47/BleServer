import 'package:drift/drift.dart';

class DeviceRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get connectionType => integer()();
  TextColumn get macAddress => text()();
  TextColumn get ip => text()();
}