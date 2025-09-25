import 'package:financial_chart/financial_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';

class LinesChart extends ConsumerStatefulWidget{
  const LinesChart({super.key});

  @override
  ConsumerState<LinesChart> createState() {
    return _LinesChartState();
  }
}

class _LinesChartState extends ConsumerState<LinesChart> with TickerProviderStateMixin {

  GChart? chart;

  @override
  void initState() {
        super.initState();
    initializeChart();
  }

  Future<void> initializeChart() async {
    final chartState = ref.watch(chartViewModelProvider);

    
       


    // load data
    loadYahooFinanceData('AAPL').then((response) {
      // build data source
      final dataSource = GDataSource<int, GData<int>>(
        dataList:
        response.candlesData.map((candle) {
          return GData<int>(
            pointValue: candle.date.millisecondsSinceEpoch,
            seriesValues: [
              candle.open,
              candle.high,
              candle.low,
              candle.close,
              candle.volume.toDouble(),
            ],
          );
        }).toList(),
        seriesProperties: const [
          GDataSeriesProperty(key: 'open', label: 'Open', precision: 2),
          GDataSeriesProperty(key: 'high', label: 'High', precision: 2),
          GDataSeriesProperty(key: 'low', label: 'Low', precision: 2),
          GDataSeriesProperty(key: 'close', label: 'Close', precision: 2),
          GDataSeriesProperty(key: 'volume', label: 'Volume', precision: 0),
        ],
      );
      setState(() {
        chart = buildChart(dataSource);
      });
    });
  }

  GChart buildChart(GDataSource dataSource) {
    // build the chart
    return GChart(
      dataSource: dataSource,
      theme: GThemeDark(),
      panels: [
        GPanel(
          valueViewPorts: [
            GValueViewPort(
              valuePrecision: 2,
              autoScaleStrategy: GValueViewPortAutoScaleStrategyMinMax(
                dataKeys: ["high", "low"],
                marginStart: GSize.viewHeightRatio(0.3),
              ),
            ),
            GValueViewPort(
              id: "volume",
              valuePrecision: 0,
              autoScaleStrategy: GValueViewPortAutoScaleStrategyMinMax(
                dataKeys: ["volume"],
                marginStart: GSize.viewSize(0),
                marginEnd: GSize.viewHeightRatio(0.7),
              ),
            ),
          ],
          valueAxes: [
            GValueAxis(),
            GValueAxis(position: GAxisPosition.start),
          ],
          pointAxes: [GPointAxis()],
          graphs: [
            GGraphGrids(),
            
            GGraphLine(valueKey: valueKey)
          ],
        ),
      ],
    );
  }

  
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Basic demo"), centerTitle: true),
      body: Container(
        child:
        chart == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(10),
          child: GChartWidget(chart: chart!, tickerProvider: this),
        ),
      ),
    );


  }

}