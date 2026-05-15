import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/common_settings/app_settings_providers.dart';
import 'package:idensity_ble_client/data_access/common_settings/app_settings_repository.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._repo) : super(ThemeMode.system) {
    _load();
  }

  final AppSettingsRepository _repo;

  Future<void> _load() async {
    final settings = await _repo.get();
    state = settings.darkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _repo.setDarkMode(mode == ThemeMode.dark);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.read(appSettingsRepositoryProvider));
});
