import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MainRealTimeWidget extends ConsumerStatefulWidget {
  const MainRealTimeWidget({super.key});

  @override
  ConsumerState<MainRealTimeWidget> createState() => _MainRealTimeWidgetState();
}

class _MainRealTimeWidgetState extends ConsumerState<MainRealTimeWidget> {
  late List<_ChartLine> _chartLines;
  late Map<String, ChartSeriesController> _controllers;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enableDirectionalZooming: true,
      enablePinching: true,
      zoomMode: ZoomMode.xy,
      enableMouseWheelZooming: true,
      enableSelectionZooming: true,
    );
    _chartLines = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        // Включаем сглаживание для отрисовки
        enableSideBySideSeriesPlacement: false,
        zoomPanBehavior: _zoomPanBehavior,
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat('HH:mm:ss'),
          intervalType: DateTimeIntervalType.seconds,
          rangePadding: ChartRangePadding.none,
          enableAutoIntervalOnZooming: false,
        ),

        primaryYAxis: const NumericAxis(axisLine: AxisLine(width: 0)),

        series:
            _chartLines.map((chartLine) {
              return LineSeries<_ChartData, DateTime>(
                name: chartLine.name,
                onRendererCreated:
                    (controller) => _controllers[chartLine.name] = controller,
                dataSource: chartLine.points,
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                color: Colors.cyan,                
                animationDuration: 200,
              );
            }).toList(),
      ),
    );
  }

  _addData(Device device) {}
}

class _ChartData {
  _ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class _ChartLine {
  final List<_ChartData> points = [];
  final String name;

  _ChartLine({required this.name});
}
