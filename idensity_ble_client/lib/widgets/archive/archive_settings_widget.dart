import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/data_log_cells/data_log_cells_repository_provider.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/add_edit_chart_settings_item_widget.dart';

class ArchiveSettingsWidget extends ConsumerStatefulWidget {
  const ArchiveSettingsWidget({
    super.key,
    required this.initialLines,
    required this.initialStart,
    required this.initialEnd,
    required this.onApply,
  });

  final List<ChartSettings> initialLines;
  final DateTime initialStart;
  final DateTime initialEnd;
  final void Function(
    List<ChartSettings> lines,
    DateTime start,
    DateTime end,
  ) onApply;

  @override
  ConsumerState<ArchiveSettingsWidget> createState() =>
      _ArchiveSettingsWidgetState();
}

class _ArchiveSettingsWidgetState extends ConsumerState<ArchiveSettingsWidget> {
  late List<ChartSettings> _lines;
  late DateTime _start;
  late DateTime _end;
  List<String> _deviceNames = [];

  @override
  void initState() {
    super.initState();
    _lines = List.from(widget.initialLines);
    _start = widget.initialStart;
    _end = widget.initialEnd;
    _loadDeviceNames();
  }

  Future<void> _loadDeviceNames() async {
    final repo = ref.read(dataLogCellsRepositoryProvider);
    final names = await repo.getDeviceNames(from: _start, to: _end);
    if (mounted) setState(() => _deviceNames = names);
  }

  Future<void> _pickDateTime(bool isStart) async {
    final initial = isStart ? _start : _end;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;
    final dt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isStart) {
        _start = dt;
      } else {
        _end = dt;
      }
    });
    _loadDeviceNames();
  }

  void _deleteLine(int index, ChartSettings removed) {
    setState(() => _lines.removeAt(index));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Удалено'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () => setState(() => _lines.insert(index, removed)),
        ),
      ),
    );
  }

  Widget _dismissBackground(DismissDirection direction) => Container(
        color: Colors.red,
        alignment: direction == DismissDirection.startToEnd
            ? Alignment.centerLeft
            : Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      );

  void _openAddEditSheet({int? editIndex}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: AddEditChartSettingsItemWidget(
          deviceNames: _deviceNames,
          chartSettings: editIndex != null ? _lines[editIndex] : null,
          onSave: (settings) async {
            setState(() {
              if (editIndex != null) {
                _lines[editIndex] = settings;
              } else {
                _lines.add(settings);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Настройки архива',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(_formatDt(_start)),
                  onPressed: () => _pickDateTime(true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: Text(_formatDt(_end)),
                  onPressed: () => _pickDateTime(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Кривые',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextButton.icon(
                onPressed: () => _openAddEditSheet(),
                icon: const Icon(Icons.add),
                label: const Text('Добавить'),
              ),
            ],
          ),
          if (_lines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Нет кривых',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _lines.length,
              itemBuilder: (_, i) {
                final line = _lines[i];
                return Dismissible(
                  key: ValueKey(line),
                  background: _dismissBackground(DismissDirection.startToEnd),
                  secondaryBackground: _dismissBackground(DismissDirection.endToStart),
                  onDismissed: (_) => _deleteLine(i, line),
                  child: Card(
                    child: ListTile(
                      onLongPress: () => _openAddEditSheet(editIndex: i),
                      title: Text('Устройство: ${line.deviceName}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Тип кривой: ${getByIndexFromList(line.chartType.index, chartNames)}'),
                          Text('Ось: ${line.rightAxis ? "Правая" : "Левая"}'),
                        ],
                      ),
                      trailing: CircleAvatar(
                        backgroundColor: line.color,
                        maxRadius: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_lines, _start, _end);
                Navigator.pop(context);
              },
              child: const Text('Применить'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
