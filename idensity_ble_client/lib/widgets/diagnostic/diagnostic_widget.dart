// lib/widgets/diagnostic/diagnostic_widget.dart
// Переделан под палитру RTK:
//  - Список карточек вместо DataTable (читается на узких экранах)
//  - Каждая карточка с акцентом-полоской слева цвета error
//  - Чип "АКТИВНА" + код события + время справа
//  - Описание ошибки крупным текстом, имя устройства — мелким серым
//  - Empty-state: зелёная иконка ✓ "Активных ошибок нет"

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/theme/app_theme.dart';
import 'package:intl/intl.dart';

class DiagnosticWidget extends ConsumerWidget {
  const DiagnosticWidget({super.key});

  static final _dfTime = DateFormat('HH:mm:ss');
  static final _dfDate = DateFormat('dd.MM.yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(diagnosticAllActiveEventsProvider);

    return eventsAsync.when(
      data: (rows) {
        if (rows.isEmpty) {
          return const _EmptyState();
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          itemCount: rows.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, i) => _EventCard(row: rows[i]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Ошибка загрузки диагностики: $e',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// ─── Empty state ────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final successColor = Theme.of(context).extension<AppExtras>()!.success;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: successColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 44,
              color: successColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Активных ошибок нет',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Все системы в норме',
            style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─── Event card ─────────────────────────────────────────────────
class _EventCard extends StatelessWidget {
  const _EventCard({required this.row});
  final dynamic row;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final dt = row.event.lastActiveTime as DateTime;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // Акцент-полоска слева
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: cs.error,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Верхняя строка: чип + код + время
                  Row(
                    children: [
                      _SeverityChip(label: 'АКТИВНА', color: cs.error),
                      const SizedBox(width: 8),
                      if ((row.event.id as String).isNotEmpty)
                        Flexible(
                          child: Text(
                            row.event.id,
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.onSurfaceVariant,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const Spacer(),
                      Text(
                        DiagnosticWidget._dfTime.format(dt),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DiagnosticWidget._dfDate.format(dt),
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Описание
                  Text(
                    row.event.description,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Имя устройства
                  Row(
                    children: [
                      Icon(Icons.devices_outlined,
                          size: 14, color: cs.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        row.deviceName,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

// ─── Severity chip ──────────────────────────────────────────────
class _SeverityChip extends StatelessWidget {
  const _SeverityChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: color,
        ),
      ),
    );
  }
}
