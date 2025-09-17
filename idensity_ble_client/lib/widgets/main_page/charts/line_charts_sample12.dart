import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/chart_state.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/app_colors.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/app_utils.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/color_extensions.dart';
import 'package:intl/intl.dart';

class LineChartSample12 extends ConsumerWidget {
  LineChartSample12({super.key});

  final _transformationController = TransformationController();
  final bool _isPanEnabled = true;
  final bool _isScaleEnabled = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const leftReservedSize = 52.0;
    final chartState = ref.watch(chartViewModelProvider);
    return Column(
      spacing: 16,
      children: [
        if (chartState.data.isNotEmpty)
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
                  lineBarsData:
                      chartState.data.map((curve) {
                        return LineChartBarData(
                          spots: curve.data.map((p)=> FlSpot(p.x, p.y * (curve.measUnit?.coeff ?? 0.0) + (curve.measUnit?.offset ?? 0.0))).toList(),
                          dotData: const FlDotData(show: false),
                          color: curve.color,
                          barWidth: 1,                          
                        );
                      }).toList(),

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
                            color: AppColors.contentColorRed,
                            strokeWidth: 1.5,
                            dashArray: [8, 2],
                          ),
                          FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 6,
                                color: AppColors.contentColorYellow,
                                strokeWidth: 0,
                                strokeColor: AppColors.contentColorYellow,
                              );
                            },
                          ),
                        );
                      }).toList();
                    },
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final price = barSpot.y;
                          final date = DateTime.fromMillisecondsSinceEpoch(
                            chartState.data[0].data[barSpot.barIndex].x.toInt(),
                          );
                          return LineTooltipItem(
                            '',
                            const TextStyle(
                              color: AppColors.contentColorBlack,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: '${date.year}/${date.month}/${date.day}',
                                style: TextStyle(
                                  color: AppColors.contentColorGreen.darken(20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '\n${AppUtils.getFormattedCurrency(context, price, noDecimals: true)}',
                                style: const TextStyle(
                                  color: AppColors.contentColorYellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                      getTooltipColor:
                          (LineBarSpot barSpot) => AppColors.contentColorBlack,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      drawBelowEverything: true,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: leftReservedSize,
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
    );
  }

  double getInterval(ChartState state) {
    if (state.data[0].data.isEmpty)
      return 30000000;
    else {
      return (state.data[0].data[state.data[0].data.length - 1].x -
              state.data[0].data[0].x) /
          10;
    }
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
                child:
                    dateMax.hour != dateMin.hour
                        ? Text(
                          DateFormat('dd.MM.yyyy HH:mm:ss').format(date),
                          style: const TextStyle(fontSize: 12),
                        )
                        : Text(
                          DateFormat('HH:mm:ss').format(date),
                          style: const TextStyle(fontSize: 12),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartTitle extends StatelessWidget {
  const _ChartTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14),
        Text(
          'Bitcoin Price History',
          style: TextStyle(
            color: AppColors.contentColorYellow,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          '2023/12/19 - 2024/12/17',
          style: TextStyle(
            color: AppColors.contentColorGreen,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 14),
      ],
    );
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
