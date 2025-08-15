import 'package:fl_chart/fl_chart.dart';

class CurbeData {
  final String deviceName;
  final String curveName;
  final List<FlSpot> data;

  CurbeData({
    required this.deviceName,
    required this.curveName,
    required this.data,
  });
}
