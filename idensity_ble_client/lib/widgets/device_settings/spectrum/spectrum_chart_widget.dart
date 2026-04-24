import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/adc/adc_frame.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpectrumChartWidget extends StatelessWidget {
  const SpectrumChartWidget({super.key, required this.frame});

  final AdcFrame frame;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: const ChartTitle(text: 'Спектр'),
      primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Канал')),
      primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Счёт')),
      series: [
        FastLineSeries<int, int>(
          dataSource: frame.samples,
          xValueMapper: (_, i) => i,
          yValueMapper: (v, _) => v,
          color: Colors.blue,
        ),
      ],
    );
  }
}
