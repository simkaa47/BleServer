import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/models/charts/line_point.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/resources/enums.dart';

class ChartLine {
  String get id =>
      "$deviceName:${getByIndexFromList(chartType.index, chartNames)}";
  final List<LinePoint> points;
  final String deviceName;
  final ChartType chartType;
  Color color;
  MeasUnit? measUnit;
  bool isRight;
  ChartLine({
    required this.deviceName,
    required this.chartType,
    this.color = Colors.black,
    required this.points,
    this.isRight = false,
    this.measUnit,
  });
}
