import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';

class CommonSettingsWidget extends ConsumerWidget {
  const CommonSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(deviceServiceProvider);
    final device = ref.watch(selectedDeviceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Общие настройки")),
      body: StreamBuilder(
        stream: device?.settingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
            final settings = snapshot.data!;
            return ListView(
              children: [
                ComboboxParameterWidget(
                  name: 'Тип устройства',
                  value: settings.deviceMode.index ?? 0,
                  options: devicesTypes,
                  onConfirm: (value) async {
                    if (DeviceMode.values.length > value) {
                      settings.deviceMode = DeviceMode.values[value];
                      device?.updateDeviceSettings(settings);
                    }

                    await service.writeDeviceType(value, device!);
                  },
                ),
              ],
            );
          }
          return const Center(child: Text("Нет устройства"));
        },
      ),
      // body:
      //     device != null
      //         ? ListView(
      //           children: [
      //             ComboboxParameterWidget(
      //               name: 'Тип устройства',
      //               value: device.deviceSettings?.deviceMode.index ?? 0,
      //               options: devicesTypes,
      //               onConfirm: (value) async{
      //                 await service.writeDeviceType(value, device);
      //               },
      //             ),
      //           ],
      //         )
      //         : const Center(child: Text("Нет устройства")),
    );
  }
}
