import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/DataLogCells/data_log_cells_repository_provider.dart';
import 'package:idensity_ble_client/data_access/common_settings/app_settings_providers.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';
import 'package:idensity_ble_client/models/charts/line_point.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/chart_helpers.dart';

class ChartInitController extends AsyncNotifier<Map<String, ChartLine>> {  

  @override
  Future<Map<String, ChartLine>> build() async {
    // Ждём зависимости
    final chartSettings = await ref.watch(chartSettingsStreamProvider.future);
    final devices = await ref.watch(devicesStreamProvider.future);
    final muService = await ref.watch(measUnitServiceProvider.future);
    final settings = await ref.watch(appSettingsProvider.future);
    final window = settings.chartWindow;
   
    final repo = ref.read(dataLogCellsRepositoryProvider);

    final now = DateTime.now();
    final lines = <String, ChartLine>{};

    for (final s in chartSettings) {
      final device = devices.where((d) => d.name == s.deviceName).firstOrNull;
      if (device == null) continue;

      final history = await repo.getHistory(
        deviceName: s.deviceName,
        chartType: s.chartType,
        from: now.subtract(window),
        to: now,
      );

      final points = history.map((e) => LinePoint(e.dt, e.value)).toList();      

      final line = ChartLine(
        deviceName: device.name,
        chartType: s.chartType,
        isRight: s.rightAxis,
        color: s.color,
        measUnit: ChartHelpers.getMeasUnit(
          s.chartType,
          muService,
          device.name,
          devices,
        ),
        points:
            points.isNotEmpty
                ? points
                : [
                  LinePoint(
                    now,
                    ChartHelpers.getValueFromDevice(device, s.chartType),
                  ),
                ],
      );
      lines[line.id] = line;
    }

    return lines;
  }
}
