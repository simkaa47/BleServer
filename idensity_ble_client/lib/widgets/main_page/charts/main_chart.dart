import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/common_settings/app_settings_providers.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';
import 'package:idensity_ble_client/models/charts/line_point.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/app_settings.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/chart_helpers.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/chart_init_provider.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/charts_overlay_legend.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/edit_charts_settings_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainChart extends ConsumerStatefulWidget {
  const MainChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _MainChartState();
  }
}

class _MainChartState extends ConsumerState<ConsumerStatefulWidget> {
  final Map<String, ChartSeriesController?> _controllers = {};
  Map<String, ChartLine> _chartLines = {};
  late final ZoomPanBehavior _zoomPanBehavior;
  AppSettings? _settings;

  @override
  void initState() {
    super.initState();

    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enableDirectionalZooming: true,
      enablePinching: true,
      zoomMode: ZoomMode.xy,
      enableMouseWheelZooming: true,
      enableSelectionZooming: true,
    );

    ref.listenManual<AsyncValue<Device>>(deviceUpdateProvider, (prev, next) {
      next.whenData(_addData);
    });

    ref.listenManual(changeMeasUnitSelectingProvider, (previous, next) {
      next.whenData((update) {
        _updateMeasUnits();
      });
    });

    ref.listenManual<AppSettings?>(appSettingsProvider.select((a) => a.value), (
      _,
      next,
    ) {
      if (next == null) return;
      _settings = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chartAsync = ref.watch(chartInitProvider);

    return chartAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text(e.toString()),
      data: _buildChart,
    );
  }

  Widget _buildChart(Map<String, ChartLine> lines) {
    _chartLines = lines;
    final left = lines.values.where((l) => !l.isRight).toList();
    final right = lines.values.where((l) => l.isRight).toList();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SfCartesianChart(
            key: ValueKey('${left.isNotEmpty}-${right.isNotEmpty}'),
            // Включаем сглаживание для отрисовки
            enableSideBySideSeriesPlacement: false,
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('HH:mm:ss'),
              desiredIntervals: 5,
              intervalType: DateTimeIntervalType.seconds,
              rangePadding: ChartRangePadding.none,
              enableAutoIntervalOnZooming: true,
            ),

            primaryYAxis: const NumericAxis(isVisible: false),
            axes: _buildAxes(left.isNotEmpty, right.isNotEmpty),

            series:
                _chartLines.entries.map((entry) {
                  return LineSeries<LinePoint, DateTime>(
                    name: entry.value.id,
                    onRendererCreated:
                        (controller) => {
                          _controllers[entry.value.id] = controller,
                        },
                    key: ValueKey(
                      "${entry.value.id}_${entry.value.isRight ? 'right' : 'left'}",
                    ),
                    yAxisName: entry.value.isRight ? 'right' : 'left',
                    dataSource: entry.value.points,
                    xValueMapper: (data, _) => data.x,
                    yValueMapper:
                        (data, _) =>
                            data.y * (entry.value.measUnit?.coeff ?? 1) +
                            (entry.value.measUnit?.offset ?? 0),
                    color: entry.value.color,
                    animationDuration: 0,
                  );
                }).toList(),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            iconSize: 40,
            tooltip: 'Настройки',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const EditChartsSettingsWidget(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              iconSize: 40,
              icon: const Icon(Icons.zoom_out_map),
              onPressed: () => _zoomPanBehavior.reset(),
              tooltip: 'Сбросить зум',
            ),
          ),
        ),
        if(left.isNotEmpty)
        Positioned(top: 12, left: 12, child: ChartsOverlayLegend(lines: left)),
        if(right.isNotEmpty)
        Positioned(
          top: 12,
          right: 12,
          child: ChartsOverlayLegend(lines: right),
        ),
      ],
    );
  }

  List<ChartAxis> _buildAxes(bool hasLeft, bool hasRight) {
    final axes = <ChartAxis>[];

    if (hasLeft) {
      axes.add(
        const NumericAxis(
          name: 'left',
          opposedPosition: false,
          axisLine: AxisLine(width: 0),
        ),
      );
    }

    if (hasRight) {
      axes.add(
        const NumericAxis(
          name: 'right',
          opposedPosition: true,
          axisLine: AxisLine(width: 0),
        ),
      );
    }

    return axes;
  }

  _updateMeasUnits() {
    final state = ref.read(chartInitProvider).value;
    if (state == null) return;

    final muServiceAsyncState = ref.read(measUnitServiceProvider);
    if (!muServiceAsyncState.hasValue) {
      return;
    }
    final devicesAsyncValue = ref.read(devicesStreamProvider);
    if (!devicesAsyncValue.hasValue) {
      return;
    }
    final devices = devicesAsyncValue.value!;
    final muService = muServiceAsyncState.value!;
    setState(() {
      for (var line in state.values) {
        line.measUnit = ChartHelpers.getMeasUnit(
          line.chartType,
          muService,
          line.deviceName,
          devices,
        );
      }
    });
  }

  _addData(Device device) {
    if (_settings == null) {
      return;
    }
    final state = ref.read(chartInitProvider).value;
    if (state == null) return;
    final cutoff = DateTime.now().subtract(_settings!.chartWindow);
    for (final line in state.values) {
      if (line.deviceName != device.name) continue;

      final controller = _controllers[line.id];
      if (controller == null) continue;

      final dt = DateTime.now();
      final value = ChartHelpers.getValueFromDevice(device, line.chartType);

      line.points.add(LinePoint(dt, value));

      final removed = _trimOldPoints(line, cutoff);
      controller.updateDataSource(
        addedDataIndex: line.points.length - 1,
        removedDataIndex: removed > 0 ? 0 : -1,
      );
    }
  }

  int _trimOldPoints(ChartLine line, DateTime cutoff) {
    int removed = 0;

    while (line.points.isNotEmpty && line.points.first.x.isBefore(cutoff)) {
      line.points.removeAt(0);
      removed++;
    }

    return removed;
  }
}
