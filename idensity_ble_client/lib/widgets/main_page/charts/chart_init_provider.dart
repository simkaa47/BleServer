import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/chart_init_controller.dart';

final chartInitProvider =
    AsyncNotifierProvider<ChartInitController, Map<String, ChartLine>>(
  ChartInitController.new,
);