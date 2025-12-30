import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/app_database_provider.dart';
import 'package:idensity_ble_client/data_access/meas_units/drift_meas_inits_repository.dart';
import 'package:idensity_ble_client/data_access/meas_units/meas_units_repository.dart';

final measUnitsRepositoryProvider =
    Provider<MeasUnitsRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return DriftMeasInitsRepository(db);
});