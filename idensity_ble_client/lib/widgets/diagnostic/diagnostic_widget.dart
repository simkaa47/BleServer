import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:intl/intl.dart';

class DiagnosticWidget extends ConsumerWidget {
  const DiagnosticWidget({super.key});

  static final _df = DateFormat('dd.MM.yyyy HH:mm:ss');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(diagnosticAllActiveEventsProvider);

    return eventsAsync.when(
      data: (rows) {
        if (rows.isEmpty) {
          return const Center(child: Text('Ошибок нет'));
        }
        return SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('Дата/Время')),
                DataColumn(label: Text('Устройство')),
                DataColumn(label: Text('Описание')),
              ],
              rows: rows
                  .map(
                    (r) => DataRow(
                      color: WidgetStateProperty.all(Colors.red),
                      cells: [
                        DataCell(Text(_df.format(r.event.lastActiveTime), style: const TextStyle(color: Colors.white))),
                        DataCell(Text(r.deviceName, style: const TextStyle(color: Colors.white))),
                        DataCell(Text(r.event.description, style: const TextStyle(color: Colors.white))),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Ошибка: $e')),
    );
  }
}
