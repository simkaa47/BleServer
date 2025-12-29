import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/app_database_provider.dart';
import 'package:idensity_ble_client/data_access/common_settings/app_settings_repository.dart';
import 'package:idensity_ble_client/models/settings/app_settings.dart';

final appSettingsRepositoryProvider =
    Provider<AppSettingsRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return AppSettingsRepository(db);
});

final appSettingsProvider =
    StreamProvider<AppSettings>((ref) {
  return ref.read(appSettingsRepositoryProvider).watch();
});