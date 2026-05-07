import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';
import 'package:idensity_ble_client/widgets/charts/chart_legend_widget.dart';
import 'package:idensity_ble_client/models/charts/line_point.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ArchiveTrendChart extends StatelessWidget {
  const ArchiveTrendChart({
    super.key,
    required this.lines,
    required this.zoomPanBehavior,
  });

  final List<ChartLine> lines;
  final ZoomPanBehavior zoomPanBehavior;

  @override
  Widget build(BuildContext context) {
    final left = lines.where((l) => !l.isRight).toList();
    final right = lines.where((l) => l.isRight).toList();

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SfCartesianChart(
                  enableSideBySideSeriesPlacement: false,
                  zoomPanBehavior: zoomPanBehavior,
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('dd.MM HH:mm'),
                    desiredIntervals: 5,
                    enableAutoIntervalOnZooming: true,
                  ),
                  primaryYAxis: const NumericAxis(isVisible: false),
                  axes: _buildAxes(left.isNotEmpty, right.isNotEmpty),
                  series: lines.map((line) {
                    return LineSeries<LinePoint, DateTime>(
                      name: line.id,
                      yAxisName: line.isRight ? 'right' : 'left',
                      dataSource: line.points,
                      xValueMapper: (data, _) => data.x,
                      yValueMapper: (data, _) => data.y,
                      color: line.color,
                      animationDuration: 0,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        ChartLegendWidget(lines: lines),
      ],
    );
  }

  List<ChartAxis> _buildAxes(bool hasLeft, bool hasRight) {
    final axes = <ChartAxis>[];
    if (hasLeft) {
      axes.add(const NumericAxis(
        name: 'left',
        opposedPosition: false,
        axisLine: AxisLine(width: 0),
      ));
    }
    if (hasRight) {
      axes.add(const NumericAxis(
        name: 'right',
        opposedPosition: true,
        axisLine: AxisLine(width: 0),
      ));
    }
    return axes;
  }
}
