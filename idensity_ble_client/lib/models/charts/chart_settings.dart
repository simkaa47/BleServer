import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';

class ChartSettings {

  ChartSettings({required this.color, required this.deviceName, required this.chartType, this.rightAxis = false});

  int? id;
  bool rightAxis = false;
  Color color;
  String deviceName = "";
  ChartType chartType;  
}