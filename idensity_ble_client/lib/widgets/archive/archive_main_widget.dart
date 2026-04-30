import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/data_log_cells/data_log_cells_repository_provider.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/archive/csv_export_service.dart';
import 'package:idensity_ble_client/widgets/archive/archive_provider.dart';
import 'package:idensity_ble_client/widgets/archive/archive_settings_widget.dart';
import 'package:idensity_ble_client/widgets/archive/archive_trend_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ArchiveMainWidget extends ConsumerStatefulWidget {
  const ArchiveMainWidget({super.key});

  @override
  ConsumerState<ArchiveMainWidget> createState() => _ArchiveMainWidgetState();
}

class _ArchiveMainWidgetState extends ConsumerState<ArchiveMainWidget> {
  final _zoomPanBehavior = ZoomPanBehavior(
    enablePanning: true,
    enableDirectionalZooming: true,
    enablePinching: true,
    zoomMode: ZoomMode.xy,
    enableMouseWheelZooming: true,
    enableSelectionZooming: true,
  );

  @override
  void initState() {
    super.initState();
    _updateAppBar(hasData: false);
  }

  void _updateAppBar({required bool hasData}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(appBarActionsProvider.notifier).state = [
        if (hasData)
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Экспорт в CSV',
            onPressed: _exportCsv,
          ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _openSettings,
        ),
        IconButton(
          icon: const Icon(Icons.update),
          onPressed: _loadData,
        ),
      ];
    });
  }

  Future<void> _exportCsv() async {
    final state = ref.read(archiveProvider);
    try {
      final path = await CsvExportService.export(
        lines: state.chartData,
        from: state.startTime,
        to: state.endTime,
      );
      if (mounted && path != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Сохранено: $path')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Ошибка экспорта: $e'),
          ),
        );
      }
    }
  }

  void _openSettings() {
    final state = ref.read(archiveProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ArchiveSettingsWidget(
        initialLines: state.chartLines,
        initialStart: state.startTime,
        initialEnd: state.endTime,
        onApply: (lines, start, end) {
          ref.read(archiveProvider.notifier).applySettings(lines, start, end);
          _loadData();
        },
      ),
    );
  }

  Future<void> _loadData() async {
    await ref
        .read(archiveProvider.notifier)
        .loadData(ref.read(dataLogCellsRepositoryProvider));
    _zoomPanBehavior.reset();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(archiveProvider);

    _updateAppBar(hasData: state.chartData.isNotEmpty);

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.chartData.isEmpty) {
      return const Center(
        child: Text('Нажмите "Обновить" для загрузки данных'),
      );
    }
    return ArchiveTrendChart(
      lines: state.chartData,
      zoomPanBehavior: _zoomPanBehavior,
    );
  }
}
