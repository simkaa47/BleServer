import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/chart_state.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/models/charts/curve_data.dart';
import 'package:idensity_ble_client/models/charts/log_cells_list.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/services/meas_units/meas_unit_service.dart';
import 'package:rxdart/rxdart.dart';

class MainChartViewModel extends Notifier<ChartState> {
  final List<LogCellsList> _dataLogCells = [];

  bool pointAdded = false;

  @override
  ChartState build() {
    final deviceAsyncState = ref.watch(deviceUpdateProvider);
    final measUnitServiceAsyncState = ref.watch(measUnitServiceProvider);
    final selectMeasUnitsAsyncValue = ref.watch(
      changeMeasUnitSelectingProvider,
    );
    final chartSettingsAsyncState = ref.watch(chartSettingsStreamProvider);

    if (deviceAsyncState.hasValue &&
        chartSettingsAsyncState.hasValue &&
        measUnitServiceAsyncState.hasValue &&
        selectMeasUnitsAsyncValue.hasValue) {
      final device = deviceAsyncState.value;
      final chartSettings = chartSettingsAsyncState.value;
      final MeasUnitService? muService = measUnitServiceAsyncState.value;
      DateTime dt = DateTime.now();
      if (device != null && muService != null) {
        _addToLogCells(device, ChartType.temp, dt);
        _addToLogCells(device, ChartType.hv, dt);
        _addToLogCells(device, ChartType.counter, dt);
        _addToLogCells(device, ChartType.currentValue0, dt);
        _addToLogCells(device, ChartType.averageValue0, dt);
        _addToLogCells(device, ChartType.currentValue1, dt);
        _addToLogCells(device, ChartType.averageValue1, dt);
        _deleteOldPoints(dt);
        final settingsMap = {
          for (var s in chartSettings!) (s.deviceName, s.chartType): s,
        };

        final state = ChartState(
          data:
              _dataLogCells
                  .where(
                    (l) => settingsMap.containsKey((l.deviceName, l.chartType)),
                  )
                  .map((l) {
                    final settings = settingsMap[(l.deviceName, l.chartType)]!;

                    return CurveData(
                      deviceName: l.deviceName,
                      curveName: _getChartName(device, l.chartType),
                      chartType: l.chartType,
                      data: l.data,
                      measUnit: _getMeasUnit(l.chartType, muService, device),
                      color: settings.color,
                    );
                  })
                  .toList(),
        );
        return state;
      }
    }
    return ChartState(data: []);
  }

  void _addToLogCells(Device device, ChartType chartType, DateTime time) {
    var log =
        _dataLogCells
            .where(
              (c) => c.chartType == chartType && c.deviceName == device.name,
            )
            .firstOrNull;
    if (log == null) {
      log = LogCellsList(
        deviceName: device.name,
        chartType: chartType,
        data: [],
      );
      _dataLogCells.add(log);
    }
    switch (chartType) {
      case ChartType.temp:
        log.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.temperature ?? 0.0,
          ),
        );
        break;
      case ChartType.hv:
        log.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.hv ?? 0.0,
          ),
        );
        break;
      case ChartType.counter:
        log.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.counters ?? 0.0,
          ),
        );
        break;
      case ChartType.averageValue0:
        log.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[0].averageValue ?? 0.0,
          ),
        );
        break;
      case ChartType.currentValue0:
        log.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[0].currentValue ?? 0.0,
          ),
        );
        break;
      case ChartType.averageValue1:
        log.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[1].averageValue ?? 0.0,
          ),
        );
        break;
      case ChartType.currentValue1:
        log.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[1].currentValue ?? 0.0,
          ),
        );
        break;
      default:
    }
  }

  void _deleteOldPoints(DateTime time) {
    final dateToCompare = time.subtract(const Duration(minutes: 5));
    for (var log in _dataLogCells) {
      log.data.removeWhere(
        (p) => DateTime.fromMillisecondsSinceEpoch(
          (p.x).toInt(),
        ).isBefore(dateToCompare),
      );
    }
  }

  MeasUnit? _getMeasUnit(
    ChartType chartType,
    MeasUnitService muService,
    Device device,
  ) {
    switch (chartType) {
      case ChartType.currentValue0:
      case ChartType.averageValue0:
        return muService.getMeasUnitForMeasProc(
          device.indicationData?.measResults[0].measProcIndex ?? 0,
          device.deviceSettings?.deviceMode.index ?? 0,
        );
      case ChartType.currentValue1:
      case ChartType.averageValue1:
        return muService.getMeasUnitForMeasProc(
          device.indicationData?.measResults[1].measProcIndex ?? 0,
          device.deviceSettings?.deviceMode.index ?? 0,
        );
      default:
        return null;
    }
  }

  String _getChartName(Device device, ChartType chartType) {
    switch (chartType) {
      case ChartType.aiCurrent0:
        return "AI0, mA";
      case ChartType.aiCurrent1:
        return "AI1, mA";
      case ChartType.aoCurrent0:
        return "AO0, mA";
      case ChartType.aoCurrent1:
        return "AO1, mA";
      case ChartType.counter:
        return "Интенсивность, имп";
      case ChartType.hv:
        return "HV, В";
      case ChartType.temp:
        return "T, °C";
      case ChartType.currentValue0:
      case ChartType.averageValue0:
        return getMeasModeForDevice(
          device,
          device.indicationData?.measResults[0],
        );
      case ChartType.currentValue1:
      case ChartType.averageValue1:
        return getMeasModeForDevice(
          device,
          device.indicationData?.measResults[1],
        );
    }
  }
}
