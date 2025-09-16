import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/chart_state.dart';
import 'package:idensity_ble_client/models/charts/curve_data.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/services/meas_units/meas_unit_service.dart';

class MainChartViewModel extends Notifier<ChartState> {
  final List<CurveData> _curves = [];
  static const String temperatureName = "Т, C";
  static const String hvName = "HV";
  static const String countsName = "Каунты";
  static const String physValueCurrent1 = "physValueCurrent1";
  static const String physValueAverage1 = "physValueAverage1";
  static const String physValueCurrent2 = "physValueCurrent2";
  static const String physValueAverage2 = "physValueAverage2";
  bool pointAdded = false;

  @override
  ChartState build() {
    final deviceAsyncState = ref.watch(deviceUpdateProvider);
    final measUnitServiceAsyncState = ref.watch(measUnitServiceProvider);

    if (deviceAsyncState.hasValue && measUnitServiceAsyncState.hasValue) {
      final device = deviceAsyncState.value;
      final MeasUnitService? muService = measUnitServiceAsyncState.value;
      DateTime dt = DateTime.now();      
      if (device != null && muService != null) {
        _addToCurve(device, temperatureName, dt, muService);
        _addToCurve(device, hvName, dt, muService);
        _addToCurve(device, countsName, dt, muService);
        _addToCurve(device, physValueCurrent1, dt, muService);
        _addToCurve(device, physValueAverage1, dt, muService);
        _addToCurve(device, physValueCurrent2, dt, muService);
        _addToCurve(device, physValueAverage2, dt, muService);
        _deleteOldPoints(dt);   
      }
    }
    return ChartState(data: [..._curves]);
  }

  void _addToCurve(
    Device device,
    String curveId,
    DateTime time,
    MeasUnitService muService,
  ) {
    var curve =
        _curves
            .where((c) => c.curveName == curveId && c.deviceName == device.name)
            .firstOrNull;    
    
    if(curve == null){
      curve = CurveData(deviceName: device.name, curveName: curveId, data: [], measUnit: _getMeasUnit(curveId, muService, device));
      _curves.add(curve);
    }
    switch (curveId) {
      case temperatureName:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.temperature ?? 0.0,
          ),
        );
        break;
      case hvName:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.hv ?? 0.0,
          ),
        );
        break;
      case countsName:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.counters ?? 0.0,
          ),
        );
        break;
        case physValueAverage1:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[0].averageValue ?? 0.0,
          ),
        );
        break;
        case physValueCurrent1:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[0].currentValue ?? 0.0,
          ),
        );
        break;
        case physValueAverage2:
        curve.data.add(
          FlSpot(
            time.millisecondsSinceEpoch.toDouble(),
            device.indicationData?.measResults[1].averageValue ?? 0.0,
          ),
        );
        break;
        case physValueCurrent2:
        curve.data.add(
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
    for (var curve in _curves) {
      curve.data.removeWhere(
        (p) => DateTime.fromMillisecondsSinceEpoch(
          (p.x).toInt(),
        ).isBefore(dateToCompare),
      );
    }
  }  

  MeasUnit? _getMeasUnit(
    String curveId,
    MeasUnitService muService,
    Device device,
  ) {
    switch (curveId) {
      case temperatureName:
        return MeasUnit(
          name: "°C",
          coeff: 1,
          offset: 0,
          deviceMode: DeviceMode.density,
          measMode: 0,
          userCantDelete: false,
        );
      case hvName:
        return MeasUnit(
          name: "В",
          coeff: 1,
          offset: 0,
          deviceMode: DeviceMode.density,
          measMode: 0,
          userCantDelete: false,
        );
      case countsName:
        return MeasUnit(
          name: "имп.",
          coeff: 1,
          offset: 0,
          deviceMode: DeviceMode.density,
          measMode: 0,
          userCantDelete: false,
        );
      case physValueAverage1:
      case physValueCurrent1:
        return muService.getMeasUnitForMeasProc(
          device.indicationData?.measResults[0].measProcIndex ?? 0,
          device.deviceSettings?.deviceMode.index ?? 0,
        );
      case physValueAverage2:
      case physValueCurrent2:
        return muService.getMeasUnitForMeasProc(
          device.indicationData?.measResults[1].measProcIndex ?? 0,
          device.deviceSettings?.deviceMode.index ?? 0,
        );
    }
    return null;
  }
}
