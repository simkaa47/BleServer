import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';



class ChartsMainWidget extends ConsumerWidget {
   

  const ChartsMainWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartState = ref.watch(chartViewModelProvider);    
    const zDataColor = Colors.red;
    return Stack(
      children: [
         Positioned(
            left: 100,
            top: 50,
            child: Column(
              children: chartState.data.map((e) => Text(e.curveName)).toList(),              
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LineChart(
                  duration: const Duration(milliseconds: 1),

                  LineChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: const FlTitlesData(
                          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))
                      ),
                      lineTouchData: const LineTouchData(enabled: false),
                      minY: 0,
                      maxY: 50,
                      lineBarsData: chartState.data.map((e) => lineChartBarData(e.data, zDataColor)).toList()
                  )
              ),
            ),
          ),
      ],
      
    );
  }


  LineChartBarData lineChartBarData(List<FlSpot> spotData , [Color color = Colors.red]){
    return LineChartBarData(
      color: color,
      spots: spotData,
        dotData: const FlDotData(
          show: false,
        ),
      //curveSmoothness: 2,
      isCurved: true
    );
  }
}
