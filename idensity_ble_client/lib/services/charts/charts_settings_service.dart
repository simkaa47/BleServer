import 'package:idensity_ble_client/models/charts/chart_settings.dart';

abstract interface class ChartsSettingsService {
  List<ChartSettings> get settings;
  Stream<List<ChartSettings>> get settingsStream;

  Future<void> init();
  Future<void> addSettings(ChartSettings setts);
  Future<void> editSettings(ChartSettings setts);
  Future<void> deleteSettings(ChartSettings setts);
}
