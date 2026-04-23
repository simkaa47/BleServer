import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/counter_mode.dart';
import 'package:idensity_ble_client/models/settings/counter_settings.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';

class CounterSettingsWidget extends ConsumerWidget {
  const CounterSettingsWidget({super.key});

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

  Widget _onData(Device? device, DeviceService deviceService) {
    if (device == null) return const Text("Ожидание данных");

    return StreamBuilder(
      stream: device.settingsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
          final counter = snapshot.data?.counterSettings[0];
          if (counter != null) {
            return _buildContent(counter, deviceService, device);
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  CounterSettings _copy(CounterSettings c) => CounterSettings()
    ..mode = c.mode
    ..start = c.start
    ..width = c.width;

  Widget _buildContent(CounterSettings counter, DeviceService deviceService, Device device) {
    return Scaffold(
      appBar: AppBar(title: const Text("Счетчики")),
      body: ListView(children: [
        ComboboxParameterWidget(
          name: "Режим",
          value: counter.mode.index,
          options: const ["Фиксированный", "Следящий", "Весь диапазон"],
          onConfirm: (value) async {
            final updated = _copy(counter)..mode = CounterMode.values[value];
            await deviceService.writeCounterSettings(updated, 0, device);
          },
        ),
        TextParameterWidget(
          name: "Начало",
          value: counter.start,
          minValue: 0,
          maxValue: 4095-counter.width,
          onConfirm: (value) async {
            final updated = _copy(counter)..start = value.toInt();
            await deviceService.writeCounterSettings(updated, 0, device);
          },
        ),
        TextParameterWidget(
          name: "Ширина",

          value: counter.width,
          minValue: 0,
          maxValue: 4095 - counter.start,
          onConfirm: (value) async {
            final updated = _copy(counter)..width = value.toInt();
            await deviceService.writeCounterSettings(updated, 0, device);
          },
        ),
      ]),
    );
  }
}
