import 'dart:async';

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
import 'package:idensity_ble_client/widgets/charts/chart_legend_widget.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/edit_charts_settings_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainChart extends ConsumerStatefulWidget {
  const MainChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainChartState();
}

class _MainChartState extends ConsumerState<ConsumerStatefulWidget> {
  final Map<String, ChartSeriesController?> _controllers = {};
  Map<String, ChartLine> _chartLines = {};
  late final ZoomPanBehavior _zoomPanBehavior;
  AppSettings? _settings;
  final List<StreamSubscription<dynamic>> _settingsSubscriptions = [];

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

    ref.listenManual<AppSettings?>(
      appSettingsProvider.select((a) => a.value),
      (_, next) {
        if (next == null) return;
        _settings = next;
      },
    );

    ref.listenManual<AsyncValue<List<Device>>>(devicesStreamProvider, (_, next) {
      next.whenData(_subscribeToDeviceSettings);
    });
  }

  void _subscribeToDeviceSettings(List<Device> devices) {
    for (final sub in _settingsSubscriptions) {
      sub.cancel();
    }
    _settingsSubscriptions.clear();

    for (final device in devices) {
      _settingsSubscriptions.add(
        device.settingsStream.listen((_) {
          if (mounted) _updateMeasUnits();
        }),
      );
    }
  }

  @override
  void dispose() {
    for (final sub in _settingsSubscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chartAsync = ref.watch(chartInitProvider);
    final appSettingsAsyncState = ref.read(appSettingsProvider);

    if (appSettingsAsyncState.hasValue) {
      _settings = appSettingsAsyncState.value;
    }

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

    final cs = Theme.of(context).colorScheme;

    final axisLabelStyle = TextStyle(
      color: cs.onSurfaceVariant,
      fontSize: 11,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final axisLineStyle = AxisLine(width: 0, color: cs.outline);
    final majorGridStyle = MajorGridLines(
      width: 1,
      color: cs.outlineVariant,
      dashArray: const [3, 4],
    );
    const majorTickStyle = MajorTickLines(size: 0);

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: SfCartesianChart(
              key: ValueKey('${left.isNotEmpty}-${right.isNotEmpty}'),
              enableSideBySideSeriesPlacement: false,
              zoomPanBehavior: _zoomPanBehavior,
              plotAreaBorderWidth: 0,
              backgroundColor: cs.surface,
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat('HH:mm:ss'),
                desiredIntervals: 5,
                intervalType: DateTimeIntervalType.seconds,
                rangePadding: ChartRangePadding.none,
                enableAutoIntervalOnZooming: true,
                labelStyle: axisLabelStyle,
                axisLine: axisLineStyle,
                majorGridLines: const MajorGridLines(width: 0),
                majorTickLines: majorTickStyle,
              ),
              primaryYAxis: const NumericAxis(isVisible: false),
              axes: _buildAxes(
                hasLeft: left.isNotEmpty,
                hasRight: right.isNotEmpty,
                labelStyle: axisLabelStyle,
                axisLine: axisLineStyle,
                grid: majorGridStyle,
                tick: majorTickStyle,
              ),
              // Серии — без изменений: цвет берётся из ChartLine (user pick).
              series: _chartLines.entries.map((entry) {
                return LineSeries<LinePoint, DateTime>(
                  name: entry.value.id,
                  onRendererCreated: (controller) =>
                      _controllers[entry.value.id] = controller,
                  key: ValueKey(
                    "${entry.value.id}_${entry.value.isRight ? 'right' : 'left'}",
                  ),
                  yAxisName: entry.value.isRight ? 'right' : 'left',
                  dataSource: entry.value.points,
                  xValueMapper: (data, _) => data.x,
                  yValueMapper: (data, _) =>
                      data.y * (entry.value.measUnit?.coeff ?? 1) +
                      (entry.value.measUnit?.offset ?? 0),
                  color: entry.value.color,
                  width: 2.0,
                  animationDuration: 0,
                );
              }).toList(),
            ),
          ),
        ),

        // Тулбар чарта — иконки не накладываются на ось X.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              IconButton(
                iconSize: 22,
                color: cs.primary,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.zoom_out_map),
                onPressed: () => _zoomPanBehavior.reset(),
                tooltip: 'Сбросить зум',
              ),
              const Spacer(),
              IconButton(
                iconSize: 22,
                color: cs.primary,
                visualDensity: VisualDensity.compact,
                tooltip: 'Настройки',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const EditChartsSettingsWidget(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
        ),

        ChartLegendWidget(lines: lines.values.toList()),
      ],
    );
  }

  List<ChartAxis> _buildAxes({
    required bool hasLeft,
    required bool hasRight,
    required TextStyle labelStyle,
    required AxisLine axisLine,
    required MajorGridLines grid,
    required MajorTickLines tick,
  }) {
    final axes = <ChartAxis>[];

    if (hasLeft) {
      axes.add(NumericAxis(
        name: 'left',
        opposedPosition: false,
        labelStyle: labelStyle,
        axisLine: axisLine,
        majorGridLines: grid,
        majorTickLines: tick,
      ));
    }

    if (hasRight) {
      axes.add(NumericAxis(
        name: 'right',
        opposedPosition: true,
        labelStyle: labelStyle,
        axisLine: axisLine,
        majorGridLines: grid,
        majorTickLines: tick,
      ));
    }

    return axes;
  }

  _updateMeasUnits() {
    final state = ref.read(chartInitProvider).value;
    if (state == null) return;

    final muServiceAsyncState = ref.read(measUnitServiceProvider);
    if (!muServiceAsyncState.hasValue) return;
    final devicesAsyncValue = ref.read(devicesStreamProvider);
    if (!devicesAsyncValue.hasValue) return;
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
    if (_settings == null) return;
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
      break;
    }
    return removed;
  }
}
