import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/chart_state.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';

class MainChartViewModel extends Notifier<ChartState>{
  @override
  ChartState build() {
    ref.watch(deviceUpdateProvider);
    final deviceService = ref.read(deviceServiceProvider);
    var chartData =  deviceService.getChartData();
    return ChartState(data: chartData.data);
  }

}