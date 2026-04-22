import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:rxdart/rxdart.dart';

class AnalogInputWidget extends StatelessWidget {
  const AnalogInputWidget({
    super.key,
    required this.device,
    required this.deviceService,
    required this.inputIndex,
  });

  final Device device;
  final DeviceService deviceService;
  final int inputIndex;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Rx.combineLatest2(
        device.settingsStream,
        device.dataStream,
        (settings, indication) => (settings, indication),
      ),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final isActive = data?.$1.analogInputActivities[inputIndex] ?? false;
        final indication = data?.$2.analogInputIndications[inputIndex];

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Аналоговый вход ${inputIndex + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  trailing: Switch(
                    value: isActive,
                    onChanged: (value) =>
                        deviceService.writeAnalogInputActivity(value, inputIndex, device),
                  ),
                ),
                if (indication != null) ...[
                  _StatusRow(
                    label: 'Связь',
                    ok: indication.commState,
                    okText: 'Есть',
                    failText: 'Нет',
                  ),
                  _StatusRow(
                    label: 'Питание',
                    ok: indication.pwrState,
                    okText: 'Есть',
                    failText: 'Нет',
                  ),
                  _ValueRow(
                    label: 'Ток',
                    value: '${indication.current.toStringAsFixed(3)} мА',
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.ok,
    required this.okText,
    required this.failText,
  });

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
              Icon(
                ok ? Icons.check_circle : Icons.cancel,
                color: ok ? Colors.green : Colors.red,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                ok ? okText : failText,
                style: TextStyle(color: ok ? Colors.green : Colors.red),
              ),
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
