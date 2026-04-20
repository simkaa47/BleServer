import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/settings/stand_settings.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';

class StandWidget extends StatelessWidget {
  const StandWidget({
    super.key,
    required this.name,
    required this.stand,
    required this.onWrite,
  });

  final String name;
  final StandSettings stand;
  final Future<void> Function(StandSettings) onWrite;

  StandSettings _copy() => StandSettings()
    ..standDuration = stand.standDuration
    ..lastStandDate = stand.lastStandDate
    ..result = stand.result
    ..halfLifeResult = stand.halfLifeResult;

  @override
  Widget build(BuildContext context) {
    final date = stand.lastStandDate;
    final dateStr = '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(name, style: Theme.of(context).textTheme.titleMedium),
          trailing: TextButton(
            child: Text(dateStr),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: stand.lastStandDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                await onWrite(_copy()..lastStandDate = picked);
              }
            },
          ),
        ),
        TextParameterWidget(
          name: 'Время стандартизации, с',
          value: stand.standDuration,
          minValue: 0,
          maxValue: 9999,
          showCard: false,
          onConfirm: (value) async {
            await onWrite(_copy()..standDuration = value.toInt());
          },
        ),
        TextParameterWidget(
          name: 'Результат, имп.',
          value: stand.result,
          minValue: 0,
          maxValue: 9999999,
          fractionDigits: 1,
          showCard: false,
          onConfirm: (value) async {
            await onWrite(_copy()..result = value.toDouble());
          },
        ),
        TextParameterWidget(
          name: 'Результат (т/п), имп.',
          value: stand.halfLifeResult,
          minValue: 0,
          maxValue: 9999999,
          fractionDigits: 1,
          showCard: false,
          onConfirm: (value) async {
            await onWrite(_copy()..halfLifeResult = value.toDouble());
          },
        ),
      ],
    );
  }
}
