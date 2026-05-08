import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/device_settings/common/rtc_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';

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
                Card(
                  child: ListTile(
                    title: const Text('Серийный номер'),
                    subtitle: Text(settings.serialNumber.isEmpty ? '—' : settings.serialNumber),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Версия прошивки'),
                    subtitle: Text(settings.fwVersion.isEmpty ? '—' : settings.fwVersion),
                  ),
                ),
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
                if (settings.deviceMode == DeviceMode.level)
                  TextParameterWidget(
                    name: 'Длина уровнемера, мм',
                    minValue: 0,
                    value: settings.levelLength,
                    onConfirm:
                        (value) async =>
                            service.writeLevelLength(value.toDouble(), device!),
                  ),
                if (device != null)
                  RtcWidget(device: device, deviceService: service),
                if (device != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.restart_alt, color: Colors.red),
                      label: const Text('Перезагрузить прибор', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                      onPressed: () => _confirmReboot(context, device, service),
                    ),
                  ),
              ],
            );
          }
          return const Center(child: Text("Нет устройства"));
        },
      ),
    );
  }

  Future<void> _confirmReboot(BuildContext context, Device device, DeviceService service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Перезагрузка прибора'),
        content: const Text('Прибор будет перезагружен. Продолжить?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Перезагрузить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await service.rebootDevice(device);
    }
  }
}
