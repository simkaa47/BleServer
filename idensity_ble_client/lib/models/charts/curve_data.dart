import 'package:fl_chart/fl_chart.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';

class CurveData {
  final String deviceName;
  final String curveName;
  final List<FlSpot> data;
  MeasUnit? measUnit;

  CurveData({
    required this.deviceName,
    required this.curveName,
    required this.data,
    required this.measUnit
  });

  changeMeasUnit(MeasUnit newMeasInit){
    measUnit = newMeasInit;
  }

}
