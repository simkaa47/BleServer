import 'package:idensity_ble_client/data_access/app_database.dart';
import 'package:idensity_ble_client/data_access/chart_setting/chart_settings_extensions.dart';
import 'package:idensity_ble_client/data_access/chart_setting/chart_settings_repository.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';

class DriftChartSettingsRepository implements ChartSettingsRepository {
  final AppDatabase db;

  DriftChartSettingsRepository(this.db);

  @override
  Future<void> add(ChartSettings settings) async{
    await db.into(db.chartSettingTableRows).insertOnConflictUpdate(settings.toCompanion());
  }

  @override
  Future<bool> delete(ChartSettings settings) async{
    if (settings.id == null) {
      return false;
    }

    final deleted = await (db.delete(db.chartSettingTableRows)
          ..where((t) => t.id.equals(settings.id!)))
        .go();

    return deleted > 0;
  }

  @override
  Future<List<ChartSettings>> getSettings() async{
    final rows = await db.select(db.chartSettingTableRows).get();
    return rows.map((e) => e.toModel()).toList();
  }
}
