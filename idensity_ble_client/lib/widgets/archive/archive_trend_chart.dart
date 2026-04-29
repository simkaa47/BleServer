import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';
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
        _buildLegend(left, right),
      ],
    );
  }

  Widget _buildLegend(List<ChartLine> left, List<ChartLine> right) {
    final all = [...left, ...right];
    if (all.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Wrap(
        spacing: 16,
        runSpacing: 4,
        children: all.map((line) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: line.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(line.id, style: const TextStyle(fontSize: 11)),
            ],
          );
        }).toList(),
      ),
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
