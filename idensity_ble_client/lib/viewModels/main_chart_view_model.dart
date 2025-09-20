import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/chart_state.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/models/charts/curve_data.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/services/meas_units/meas_unit_service.dart';

class MainChartViewModel extends Notifier<ChartState> {
  final List<CurveData> _curves = [];

  bool pointAdded = false;

  @override
  ChartState build() {
    final deviceAsyncState = ref.watch(deviceUpdateProvider);
    final measUnitServiceAsyncState = ref.watch(measUnitServiceProvider);
    final selectMeasUnitsAsyncValue = ref.watch(
      changeMeasUnitSelectingProvider,
    );

    if (deviceAsyncState.hasValue &&
        measUnitServiceAsyncState.hasValue &&
        selectMeasUnitsAsyncValue.hasValue) {
      final device = deviceAsyncState.value;
      final MeasUnitService? muService = measUnitServiceAsyncState.value;
      DateTime dt = DateTime.now();
      if (device != null && muService != null) {
        _addToCurve(device, ChartType.temp, dt, muService);
        _addToCurve(device, ChartType.hv, dt, muService);
        _addToCurve(device, ChartType.counter, dt, muService);
        _addToCurve(device, ChartType.currentValue0, dt, muService);
        _addToCurve(device, ChartType.averageValue0, dt, muService);
        _addToCurve(device, ChartType.currentValue1, dt, muService);
        _addToCurve(device, ChartType.averageValue1, dt, muService);
        _deleteOldPoints(dt);
      }
    }
    return ChartState(data: [..._curves]);
  }

  void _addToCurve(
    Device device,
    ChartType chartType,
    DateTime time,
    MeasUnitService muService,
  ) {
    var curve =
        _curves
            .where((c) => c.color == chartType && c.deviceName == device.name)
            .firstOrNull;

    if (curve == null) {
      curve = CurveData(
        deviceName: device.name,
        chartType: chartType,
        curveName: _getChartName(device, chartType),
        data: [],
        measUnit: _getMeasUnit(chartType, muService, device),
        color: getColor(chartType),
      );
      _curves.add(curve);
    }
    switch (chartType) {
      case ChartType.temp:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.temperature ?? 0.0,
          ),
        );
        break;
      case ChartType.hv:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.hv ?? 0.0,
          ),
        );
        break;
      case ChartType.counter:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.counters ?? 0.0,
          ),
        );
        break;
      case ChartType.averageValue0:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[0].averageValue ?? 0.0,
          ),
        );
        curve.changeMeasUnit(_getMeasUnit(chartType, muService, device));
        break;
      case ChartType.currentValue0:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[0].currentValue ?? 0.0,
          ),
        );
        curve.changeMeasUnit(_getMeasUnit(chartType, muService, device));
        break;
      case ChartType.averageValue1:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[1].averageValue ?? 0.0,
          ),
        );
        curve.changeMeasUnit(_getMeasUnit(chartType, muService, device));
        break;
      case ChartType.currentValue1:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[1].currentValue ?? 0.0,
          ),
        );
        curve.changeMeasUnit(_getMeasUnit(chartType, muService, device));
        break;

      default:
    }
  }

  void _deleteOldPoints(DateTime time) {
    final dateToCompare = time.subtract(const Duration(minutes: 5));
    for (var curve in _curves) {
      curve.data.removeWhere(
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

  Color getColor(ChartType chartType) {
    switch (chartType) {
      case ChartType.temp:
        return Colors.black;
      case ChartType.hv:
        return Colors.red;
      case ChartType.counter:
        return Colors.brown;
      case ChartType.averageValue0:
        return Colors.blue;
      case ChartType.currentValue0:
        return Colors.green;
      case ChartType.averageValue1:
        return Colors.pink;
      case ChartType.currentValue1:
        return Colors.lightGreen;
      default:
        return Colors.black;
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
