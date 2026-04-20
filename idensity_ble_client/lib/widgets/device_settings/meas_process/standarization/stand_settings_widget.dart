import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/device_settings/meas_process/standarization/stand_widget.dart';

const _standNames = ['Фон', 'Источник'];

class StandSettingsWidget extends ConsumerWidget {
  const StandSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measProcIndex = ref.watch(selectedMeasProcIndexProvider);
    final device = ref.watch(selectedDeviceProvider);
    final deviceServiceAsyncState = ref.watch(deviceServiceProvider);

    return deviceServiceAsyncState.when(
      data: (service) => _onDeviceServiceData(device, measProcIndex, service),
      error: (e, s) => UniversalAsyncHandler.onError("Сервис устройств", e, s),
      loading: () => UniversalAsyncHandler.onLoading("Сервис устройств"),
    );
  }

  Widget _onDeviceServiceData(
    Device? device,
    int measProcIndex,
    DeviceService deviceService,
  ) {
    if (device == null) return const Text("Ожидание данных");

    return StreamBuilder(
      stream: device.settingsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
          final measProc = snapshot.data?.measProcesses[measProcIndex];
          if (measProc != null) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _standNames.length,
              itemBuilder: (context, standIndex) {
                final stand = measProc.standSettings[standIndex];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: StandWidget(
                    name: _standNames[standIndex],
                    stand: stand,
                    onWrite: (updated) async {
                      await deviceService.writeMeasProcStandartization(
                        updated,
                        standIndex,
                        measProcIndex,
                        device,
                      );
                    },
                  ),
                );
              },
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
