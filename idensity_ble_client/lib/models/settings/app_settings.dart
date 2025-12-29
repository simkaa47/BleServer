import 'package:idensity_ble_client/data_access/app_database.dart';

class AppSettings {
  const AppSettings({required this.maxChartWindowSec, required this.darkMode});

  final int maxChartWindowSec;
  final bool darkMode;

  Duration get chartWindow =>
      Duration(seconds: maxChartWindowSec);

      factory AppSettings.fromDb(CommonSetting row) {
    return AppSettings(
      maxChartWindowSec: row.maxChartWindowSec,
      darkMode: row.darkMode
    );
  }
}
