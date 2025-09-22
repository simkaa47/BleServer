import 'package:fl_chart/fl_chart.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';

class LogCellsList {
  final String deviceName;  
  final ChartType chartType;
  final List<FlSpot> data;

  LogCellsList({
    required this.deviceName,    
    required this.chartType,
    required this.data,
  });
}
