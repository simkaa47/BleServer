import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/device_settings/analogs/analog_indication_widget.dart';
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
                if (indication != null)
                  AnalogIndicationWidget(
                    indication: indication,
                    current: indication.current,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
