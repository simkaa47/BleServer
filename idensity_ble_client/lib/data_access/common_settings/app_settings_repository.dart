import 'package:drift/drift.dart';
import 'package:idensity_ble_client/data_access/app_database.dart';
import 'package:idensity_ble_client/models/settings/app_settings.dart';

class AppSettingsRepository {
  final AppDatabase _db;

  AppSettingsRepository(this._db);
  
  Future<AppSettings> get() async {
    final row = await (_db.select(_db.commonSettings)..limit(1))
        .getSingleOrNull();

    if (row != null) {
      return AppSettings.fromDb(row);
    }

    // Если таблица пустая — создаём дефолтную строку
    await _db.into(_db.commonSettings).insert(
          CommonSettingsCompanion.insert(),
        );

    final created =
        await (_db.select(_db.commonSettings)..limit(1))
            .getSingle();

    return AppSettings.fromDb(created);
  }

  /// Stream — для live-обновлений
  Stream<AppSettings> watch() {
    return (_db.select(_db.commonSettings)..limit(1))
        .watchSingleOrNull()
        .asyncMap((row) async {
      if (row != null) {
        return AppSettings.fromDb(row);
      }

      await _db.into(_db.commonSettings).insert(
            CommonSettingsCompanion.insert(),
          );

      final created =
          await (_db.select(_db.commonSettings)..limit(1))
              .getSingle();

      return AppSettings.fromDb(created);
    });
  }

  /// Изменить окно графика
  Future<void> setChartWindow(Duration window) {
    return (_db.update(_db.commonSettings)
          ..where((t) => t.id.equals(1)))
        .write(
      CommonSettingsCompanion(
        maxChartWindowSec: Value(window.inSeconds),
      ),
    );
  }
}