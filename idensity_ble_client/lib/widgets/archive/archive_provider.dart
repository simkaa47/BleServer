import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/data_log_cells/data_log_cell_repository.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/models/charts/line_point.dart';

class ArchiveState {
  const ArchiveState({
    required this.chartLines,
    required this.startTime,
    required this.endTime,
    required this.chartData,
    required this.loading,
  });

  final List<ChartSettings> chartLines;
  final DateTime startTime;
  final DateTime endTime;
  final List<ChartLine> chartData;
  final bool loading;

  ArchiveState copyWith({
    List<ChartSettings>? chartLines,
    DateTime? startTime,
    DateTime? endTime,
    List<ChartLine>? chartData,
    bool? loading,
  }) => ArchiveState(
    chartLines: chartLines ?? this.chartLines,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    chartData: chartData ?? this.chartData,
    loading: loading ?? this.loading,
  );
}

class ArchiveNotifier extends Notifier<ArchiveState> {
  @override
  ArchiveState build() => ArchiveState(
    chartLines: [
      ChartSettings(
        color: Colors.black,
        deviceName: "Idensity_BLE2",
        chartType: ChartType.counter,
      ),
    ],
    startTime: DateTime.now().subtract(const Duration(days: 1)),
    endTime: DateTime.now(),
    chartData: [],
    loading: false,
  );

  void applySettings(
    List<ChartSettings> lines,
    DateTime start,
    DateTime end,
  ) {
    state = state.copyWith(chartLines: lines, startTime: start, endTime: end);
  }

  Future<void> loadData(DataLogCellRepository repo) async {
    state = state.copyWith(loading: true);
    try {
      final lines = <ChartLine>[];
      for (final settings in state.chartLines) {
        final records = await repo.getHistory(
          deviceName: settings.deviceName,
          chartType: settings.chartType,
          from: state.startTime,
          to: state.endTime,
        );
        lines.add(ChartLine(
          deviceName: settings.deviceName,
          chartType: settings.chartType,
          color: settings.color,
          isRight: settings.rightAxis,
          points: records.map((r) => LinePoint(r.dt, r.value)).toList(),
        ));
      }
      state = state.copyWith(chartData: lines);
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}

final archiveProvider =
    NotifierProvider<ArchiveNotifier, ArchiveState>(ArchiveNotifier.new);
