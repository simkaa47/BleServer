import 'package:idensity_ble_client/models/charts/chart_settings.dart';

abstract class ChartSettingsRepository {
  Future<List<ChartSettings>> getSettings();
  Future<void> add(ChartSettings settings);
  Future<bool> delete(ChartSettings settings);
}