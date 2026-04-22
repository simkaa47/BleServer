import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/device_settings/analogs/analog_input_widget.dart';

class AnalogsCommonWidget extends ConsumerWidget {
  const AnalogsCommonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(selectedDeviceProvider);
    final deviceServiceAsyncState = ref.watch(deviceServiceProvider);

    return deviceServiceAsyncState.when(
      data: (service) => _onData(device, service),
      error: (e, s) => UniversalAsyncHandler.onError("Сервис устройств", e, s),
      loading: () => UniversalAsyncHandler.onLoading("Сервис устройств"),
    );
  }

  Widget _onData(Device? device, DeviceService service) {
    return Scaffold(
      appBar: AppBar(title: const Text("Аналоги")),
      body: StreamBuilder(
        stream: device?.settingsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
            final settings = snapshot.data!;
            return ListView(
              children: [
                for (var i = 0; i < settings.analogInputActivities.length; i++)
                  AnalogInputWidget(
                    device: device!,
                    deviceService: service,
                    inputIndex: i,
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
