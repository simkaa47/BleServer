import 'package:idensity_ble_client/models/charts/chart_type.dart';

class DataLogCell {
  int? id;
  final ChartType chartType;
  final double dt;
  final double value;
  final String deviceName;

  DataLogCell({
    required this.chartType,
    required this.dt,
    required this.value,
    required this.deviceName,
    this.id,
  });
}
