import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/indication/analog_indication.dart';

class AnalogIndicationWidget extends StatelessWidget {
  const AnalogIndicationWidget({
    super.key,
    required this.indication,
    required this.current,
  });

  final AnalogIndication indication;
  final double current;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatusRow(label: 'Связь', ok: indication.commState, okText: 'Есть', failText: 'Нет'),
        _StatusRow(label: 'Питание', ok: indication.pwrState, okText: 'Есть', failText: 'Нет'),
        _ValueRow(label: 'Ток', value: '${current.toStringAsFixed(3)} мА'),
      ],
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({required this.label, required this.ok, required this.okText, required this.failText});

  final String label;
  final bool ok;
  final String okText;
  final String failText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Row(
            children: [
              Icon(ok ? Icons.check_circle : Icons.cancel, color: ok ? Colors.green : Colors.red, size: 18),
              const SizedBox(width: 4),
              Text(ok ? okText : failText, style: TextStyle(color: ok ? Colors.green : Colors.red)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
