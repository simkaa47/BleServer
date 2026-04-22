import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';

class CommonSettingsWidget extends ConsumerWidget {
  const CommonSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceAsyncState = ref.watch(deviceServiceProvider);
    final device = ref.watch(selectedDeviceProvider);
    final serviceName = "Сервис устройств";

    return serviceAsyncState.when(
      data: (service) => _onData(device, service),
      error: (e, s) => UniversalAsyncHandler.onError(serviceName, e, s),
      loading: () => UniversalAsyncHandler.onLoading(serviceName),
    );
  }

  Widget _onData(Device? device, DeviceService service) {
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
                  value: settings.deviceMode.index,
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
    );
  }
}
