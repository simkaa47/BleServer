import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/adc/adc_frame.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OscilloscopeChartWidget extends StatelessWidget {
  const OscilloscopeChartWidget({super.key, required this.frame});

  final AdcFrame frame;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Осциллограмма'),
      primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Отсчёт')),
      primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Амплитуда')),
      series: [
        FastLineSeries<int, int>(
          dataSource: frame.samples,
          xValueMapper: (_, i) => i,
          yValueMapper: (v, _) => v,
          color: Colors.green,
        ),
      ],
    );
  }
}
