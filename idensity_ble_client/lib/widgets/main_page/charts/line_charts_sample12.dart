import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/curve_data.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/curve_indicator.dart';
import 'package:intl/intl.dart';

class LineChartSample12 extends ConsumerWidget {
  LineChartSample12({super.key});

  final _transformationController = TransformationController();
  final bool _isPanEnabled = true;
  final bool _isScaleEnabled = true;
  double minLeft = double.maxFinite;
  double maxLeft = double.minPositive;
  double minRight = double.maxFinite;
  double maxRight = double.minPositive;
  double rightDiff = 0;
  double leftDiff = 0;
  bool _rightExists = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartState = ref.watch(chartViewModelProvider);

    minLeft = double.maxFinite;
    maxLeft = double.negativeInfinity;
    minRight = double.maxFinite;
    maxRight = double.minPositive;
    _rightExists = false;
    final charts = _getLinesCharts(chartState.data);
    if (chartState.data.isNotEmpty) {
      return Expanded(
        child: Column(
          spacing: 16,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ...chartState.data
                          .where((c) => !c.rightAxis)
                          .map((c) => CurveIndicator(curve: c)),
                    ],
                  ),
                ),
                if (_rightExists)
                  Expanded(
                    child: Column(
                      children: [
                        ...chartState.data
                            .where((c) => c.rightAxis)
                            .map((c) => CurveIndicator(curve: c)),
                      ],
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.all(2),
                  child: IconButton.outlined(
                    onPressed: () {},
                    icon: const Icon(Icons.settings),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0, right: 18.0),
                child: LineChart(
                  transformationConfig: FlTransformationConfig(
                    scaleAxis: FlScaleAxis.free,
                    minScale: 1.0,
                    maxScale: 100,

                    panEnabled: _isPanEnabled,
                    scaleEnabled: _isScaleEnabled,
                    transformationController: _transformationController,
                  ),

                  LineChartData(
                    lineBarsData: charts,

                    lineTouchData: LineTouchData(
                      touchSpotThreshold: 5,
                      getTouchLineStart: (_, __) => -double.infinity,
                      getTouchLineEnd: (_, __) => double.infinity,
                      getTouchedSpotIndicator: (
                        LineChartBarData barData,
                        List<int> spotIndexes,
                      ) {
                        return spotIndexes.map((spotIndex) {
                          return TouchedSpotIndicatorData(
                            const FlLine(
                              color: Colors.red,
                              strokeWidth: 1,
                              dashArray: [8, 2],
                            ),
                            FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 6,
                                  color: Colors.yellow,
                                  strokeWidth: 0,
                                  strokeColor: Colors.amberAccent,
                                );
                              },
                            ),
                          );
                        }).toList();
                      },
                      touchTooltipData: LineTouchTooltipData(
                        fitInsideVertically: true,
                        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                          int i = 0;
                          return touchedBarSpots.map((barSpot) {
                            i++;
                            final curve = chartState.data[barSpot.barIndex];
                            final value = curve.data[barSpot.spotIndex].y;
                            final date = DateTime.fromMillisecondsSinceEpoch(
                              curve.data[barSpot.spotIndex].x.toInt(),
                            );
                            return LineTooltipItem(
                              '',
                              const TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                if (i == 1)
                                  TextSpan(
                                    text: DateFormat("HH:mm:ss").format(date),
                                  ),
                                if (i == 1)
                                  TextSpan(
                                    text: '\n${value.toStringAsPrecision(5)}',
                                    style: TextStyle(color: curve.color),
                                  ),
                                if (i != 1)
                                  TextSpan(
                                    text: value.toStringAsPrecision(5),
                                    style: TextStyle(color: curve.color),
                                  ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                    ),
                    minY: maxLeft - leftDiff * 1.1,
                    maxY: minLeft + leftDiff * 1.1,

                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        drawBelowEverything: true,
                        sideTitles: SideTitles(
                          showTitles: _rightExists,
                          reservedSize: 52,
                          getTitlesWidget: _getRightTitle,
                          maxIncluded: false,
                          minIncluded: false,
                        ),
                      ),
                      leftTitles: const AxisTitles(
                        drawBelowEverything: true,
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 52,

                          maxIncluded: false,
                          minIncluded: false,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: null,

                          reservedSize: 100,
                          minIncluded: false,
                          maxIncluded: false,
                          getTitlesWidget: getTitlesWidget,
                        ),
                      ),
                    ),
                  ),
                  duration: Duration.zero,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _getRightTitle(double value, TitleMeta meta) {
    final modified = minRight + (value - minLeft) * rightDiff / leftDiff;
    return Text(modified.toStringAsPrecision(5));
  }

  List<LineChartBarData> _getLinesCharts(List<CurveData> curves) {
    final rightCurves = curves.where((c) => c.rightAxis).toList();
    _getMinMaxValues(curves);
    leftDiff = maxLeft - minLeft;
    if (rightCurves.isNotEmpty) {
      _rightExists = true;

      rightDiff = maxRight - minRight;
    }

    return curves.map((curve) {
      return LineChartBarData(
        spots: _getSpotsForCurve(curve),
        dotData: const FlDotData(show: false),

        color: curve.color,
        barWidth: 1,
      );
    }).toList();
  }

  void _getMinMaxValues(List<CurveData> curves) {
    for (var curve in curves) {
      for (var p in curve.data) {
        if (curve.rightAxis) {
          if (p.y > maxRight) {
            maxRight = p.y;
          } else if (p.y < minRight) {
            minRight = p.y;
          }
        } else {
          if (p.y > maxLeft) {
            maxLeft = p.y;
          } else if (p.y < minLeft) {
            minLeft = p.y;
          }
        }
      }
    }
  }

  List<FlSpot> _getSpotsForCurve(CurveData curve) {
    return curve.data.map((p) {
      if (curve.rightAxis) {
        return FlSpot(p.x, minLeft + (p.y - minRight) * leftDiff / rightDiff);
      }
      return p;
    }).toList();
  }

  Widget getTitlesWidget(double value, TitleMeta meta) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final dateMin = DateTime.fromMillisecondsSinceEpoch(meta.min.toInt());
    final dateMax = DateTime.fromMillisecondsSinceEpoch(meta.max.toInt());
    return SideTitleWidget(
      meta: meta,
      child: Transform.rotate(
        angle: -45 * 3.14 / 180,

        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  _getDateFormat(date, dateMin, dateMax),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDateFormat(DateTime date, DateTime min, DateTime max) {
    if (max.isBefore(min.add(const Duration(minutes: 5)))) {
      return DateFormat("HH:mm:ss").format(date);
    } else if (max.isBefore(min.add(const Duration(days: 1)))) {
      return DateFormat("HH:mm").format(date);
    }
    return DateFormat("dd.MM.yyyy HH:mm").format(date);
  }
}

class _TransformationButtons extends StatelessWidget {
  const _TransformationButtons({required this.controller});

  final TransformationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tooltip(
          message: 'Zoom in',
          child: IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: _transformationZoomIn,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Move left',
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 16),
                onPressed: _transformationMoveLeft,
              ),
            ),
            Tooltip(
              message: 'Reset zoom',
              child: IconButton(
                icon: const Icon(Icons.refresh, size: 16),
                onPressed: _transformationReset,
              ),
            ),
            Tooltip(
              message: 'Move right',
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: _transformationMoveRight,
              ),
            ),
          ],
        ),
        Tooltip(
          message: 'Zoom out',
          child: IconButton(
            icon: const Icon(Icons.minimize, size: 16),
            onPressed: _transformationZoomOut,
          ),
        ),
      ],
    );
  }

  void _transformationReset() {
    controller.value = Matrix4.identity();
  }

  void _transformationZoomIn() {
    controller.value *= Matrix4.diagonal3Values(1.1, 1.1, 1);
  }

  void _transformationMoveLeft() {
    controller.value *= Matrix4.translationValues(20, 0, 0);
  }

  void _transformationMoveRight() {
    controller.value *= Matrix4.translationValues(-20, 0, 0);
  }

  void _transformationZoomOut() {
    controller.value *= Matrix4.diagonal3Values(0.9, 0.9, 1);
  }
}
