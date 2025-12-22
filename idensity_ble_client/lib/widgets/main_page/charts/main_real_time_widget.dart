import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/edit_charts_settings_widget.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainRealTimeWidget extends ConsumerStatefulWidget {
  const MainRealTimeWidget({super.key});

  @override
  ConsumerState<MainRealTimeWidget> createState() => _MainRealTimeWidgetState();
}

class _MainRealTimeWidgetState extends ConsumerState<MainRealTimeWidget> {
  late Map<String, _ChartLine> _chartLines;
  late Map<String, ChartSeriesController?> _controllers;
  late ZoomPanBehavior _zoomPanBehavior;
  late AsyncValue<List<ChartSettings>> _chartSettingsAsyncState;
  late AsyncValue<List<Device>> _devicesAsyncValue;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enableDirectionalZooming: true,
      enablePinching: true,
      zoomMode: ZoomMode.xy,
      enableMouseWheelZooming: true,
      enableSelectionZooming: true,
    );

    _chartLines = {};
    _controllers = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<Device>>(deviceUpdateProvider, (previous, next) {
      next.whenData((update) {
        _addData(update);
      });
    });
    _chartSettingsAsyncState = ref.watch(chartSettingsStreamProvider);
    _devicesAsyncValue = ref.watch(devicesStreamProvider);
    _rebuild();

    final chart = Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),

          child: SfCartesianChart(
            // Включаем сглаживание для отрисовки
            enableSideBySideSeriesPlacement: false,
            zoomPanBehavior: _zoomPanBehavior,
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('HH:mm:ss'),
              intervalType: DateTimeIntervalType.seconds,
              rangePadding: ChartRangePadding.none,
              enableAutoIntervalOnZooming: false,
            ),

            primaryYAxis: const NumericAxis(axisLine: AxisLine(width: 0)),

            series:
                _chartLines.entries.map((entry) {
                  return LineSeries<_ChartData, DateTime>(
                    name: entry.value.name,
                    onRendererCreated:
                        (controller) => {
                          _controllers[entry.value.name] = controller,
                        },
                    key: ValueKey(entry.value.name),
                    dataSource: entry.value.points,
                    xValueMapper: (data, _) => data.x,
                    yValueMapper: (data, _) => data.y,
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
            iconSize: 50,
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
          top: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              iconSize: 50,
              icon: const Icon(Icons.zoom_out_map),
              onPressed: () => _zoomPanBehavior.reset(),
              tooltip: 'Сбросить зум',
            ),
          ),
        ),
      ],
    );

    return _isChartSettingsNotReady()
        ? const Center(child: CircularProgressIndicator())
        : chart;
  }

  _addData(Device device) {
    if (_isChartSettingsNotReady()) {
      return;
    }

    for (var sett in _chartSettingsAsyncState.value!) {
      if (sett.deviceName == device.name) {
        final lineId = _getLineName(device, sett.chartType);

        final controller = _controllers[lineId];
        final line = _chartLines[lineId];
        if (controller == null || line == null) {
          continue;
        }
        final dt = DateTime.now();
        switch (sett.chartType) {
          case ChartType.counter:
            line.points.add(
              _ChartData(dt, device.indicationData?.counters ?? 0),
            );
            break;
          case ChartType.currentValue0:
            line.points.add(
              _ChartData(
                dt,
                device.indicationData?.measResults[0].currentValue ?? 0,
              ),
            );
            break;
          case ChartType.currentValue1:
            line.points.add(
              _ChartData(
                dt,
                device.indicationData?.measResults[1].currentValue ?? 0,
              ),
            );
            break;
          case ChartType.averageValue0:
            line.points.add(
              _ChartData(
                dt,
                device.indicationData?.measResults[0].averageValue ?? 0,
              ),
            );
            break;
          case ChartType.averageValue1:
            line.points.add(
              _ChartData(
                dt,
                device.indicationData?.measResults[1].averageValue ?? 0,
              ),
            );
            break;
          case ChartType.hv:
            line.points.add(_ChartData(dt, device.indicationData?.hv ?? 0));
            break;
          case ChartType.temp:
            line.points.add(
              _ChartData(dt, device.indicationData?.temperature ?? 0),
            );
            break;
          case ChartType.aiCurrent0:
            line.points.add(
              _ChartData(
                dt,
                device.indicationData?.analogInputIndications[0].current ?? 0,
              ),
            );
            break;
          case ChartType.aiCurrent1:
            line.points.add(
              _ChartData(
                dt,
                device.indicationData?.analogInputIndications[1].current ?? 0,
              ),
            );
            break;
          case ChartType.aoCurrent0:
            line.points.add(
              _ChartData(
                dt,
                device.indicationData?.analogOutputIndications[0].current ?? 0,
              ),
            );
            break;
          case ChartType.aoCurrent1:
            line.points.add(
              _ChartData(
                dt,
                device.indicationData?.analogOutputIndications[1].current ?? 0,
              ),
            );
            break;
        }
        controller.updateDataSource(
          addedDataIndex: line.points.length - 1,
          removedDataIndex: -1,
        );
      }
    }
  }

  void _rebuild() {
    if (_isChartSettingsNotReady() || !_devicesAsyncValue.hasValue) return;

    final devices = _devicesAsyncValue.value!;
    final chartSettings = _chartSettingsAsyncState.value!;
    final dt = DateTime.now();

    // Добавление
    for (var setting in chartSettings) {
      final lineId =
          "${setting.deviceName}:${getByIndexFromList(setting.chartType.index, chartNames)}";

      if (_chartLines.containsKey(lineId)) continue;

      if (devices.any((d) => d.name == setting.deviceName)) {
        _chartLines[lineId] = _ChartLine(
          name: lineId,
          color: setting.color,
          points: [_ChartData(dt, 0)],
        );
        _controllers[lineId] = null;
      }
    }

    // Удаление
    _chartLines.removeWhere((key, _) {
      final exists = chartSettings.any(
        (c) =>
            key ==
            "${c.deviceName}:${getByIndexFromList(c.chartType.index, chartNames)}",
      );

      if (!exists) {
        _controllers.remove(key);
      }
      return !exists;
    });
  }

  String _getLineName(Device device, ChartType type) =>
      "${device.name}:${getByIndexFromList(type.index, chartNames)}";

  bool _isChartSettingsNotReady() {
    return !_chartSettingsAsyncState.hasValue ||
        _chartSettingsAsyncState.hasError ||
        _chartSettingsAsyncState.isLoading;
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class _ChartLine {
  final List<_ChartData> points;
  final String name;
  final Color color;

  _ChartLine({required this.name, required this.color, required this.points});
}
