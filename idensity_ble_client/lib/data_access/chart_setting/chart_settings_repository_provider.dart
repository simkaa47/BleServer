import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/app_database_provider.dart';
import 'package:idensity_ble_client/data_access/chart_setting/chart_settings_repository.dart';
import 'package:idensity_ble_client/data_access/chart_setting/drift_chart_settings_repository.dart';

final chartSettingsRepositoryProvider = Provider<ChartSettingsRepository>((ref){
  final db = ref.read(appDatabaseProvider);
  return DriftChartSettingsRepository(db);
});