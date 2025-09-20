import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';

class CurveData {
  final String deviceName;
  final String curveName;
  final ChartType chartType;
  final Color color;
  final List<FlSpot> data;
  MeasUnit? measUnit;

  CurveData({
    required this.deviceName,
    required this.curveName,
    required this.chartType,
    required this.data,
    required this.measUnit,
    required this.color
  });

  changeMeasUnit(MeasUnit? newMeasInit){
    measUnit = newMeasInit;
  }

}
