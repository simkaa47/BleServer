import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/indication/measure_indication.dart';
import 'package:idensity_ble_client/models/settings/single_meas_result.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';

class SingleMeasWidget extends StatelessWidget {
  const SingleMeasWidget({
    super.key,
    required this.name,
    required this.result,
    required this.indication,
    required this.onWrite,
    required this.onStart,
    required this.onStop,
  });

  final String name;
  final SingleMeasResult result;
  final MeasureIndication indication;
  final Future<void> Function(SingleMeasResult) onWrite;
  final Future<void> Function() onStart;
  final Future<void> Function() onStop;

  SingleMeasResult _copy() => SingleMeasResult()
    ..date = result.date
    ..weak = result.weak
    ..physValue = result.physValue
    ..isChecked = result.isChecked;

  @override
  Widget build(BuildContext context) {
    final date = result.date;
    final dateStr = '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(name, style: Theme.of(context).textTheme.titleMedium),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SingleMeasButton(
                indication: indication,
                onStart: onStart,
                onStop: onStop,
              ),
              TextButton(
                child: Text(dateStr),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: result.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    await onWrite(_copy()..date = picked);
                  }
                },
              ),
            ],
          ),
        ),
        TextParameterWidget(
          name: 'Ослабление',
          value: result.weak,
          fractionDigits: 4,
          showCard: false,
          onConfirm: (value) async {
            await onWrite(_copy()..weak = value.toDouble());
          },
        ),
        TextParameterWidget(
          name: 'Физ. величина',
          value: result.physValue,
          fractionDigits: 4,
          showCard: false,
          onConfirm: (value) async {
            await onWrite(_copy()..physValue = value.toDouble());
          },
        ),
        SwitchListTile(
          title: const Text('Выбрано'),
          value: result.isChecked,
          onChanged: (value) async {
            await onWrite(_copy()..isChecked = value);
          },
        ),
      ],
    );
  }
}

class _SingleMeasButton extends StatelessWidget {
  const _SingleMeasButton({
    required this.indication,
    required this.onStart,
    required this.onStop,
  });

  final MeasureIndication indication;
  final Future<void> Function() onStart;
  final Future<void> Function() onStop;

  @override
  Widget build(BuildContext context) {
    final isActive = indication.isActive;

    return ElevatedButton(
      style: isActive ? ElevatedButton.styleFrom(backgroundColor: Colors.red) : null,
      onPressed: isActive ? onStop : onStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isActive ? Icons.stop : Icons.play_arrow),
          if (isActive) ...[
            const SizedBox(width: 4),
            Text('${indication.secondsLasted} с'),
          ],
        ],
      ),
    );
  }
}
