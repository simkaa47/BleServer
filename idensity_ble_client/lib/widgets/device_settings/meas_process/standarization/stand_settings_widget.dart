import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/device_settings/meas_process/standarization/stand_widget.dart';
import 'package:rxdart/rxdart.dart';

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

    final combined = Rx.combineLatest2(
      device.settingsStream,
      device.dataStream,
      (DeviceSettings settings, IndicationData indication) =>
          (settings, indication),
    );

    return StreamBuilder(
      stream: combined,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
          final measProc =
              snapshot.data?.$1.measProcesses[measProcIndex];
          final indication = snapshot.data?.$2;
          if (measProc != null && indication != null) {
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
                    standIndication: indication
                        .measProcessIndications[measProcIndex]
                        .standIndications[standIndex],
                    onWrite: (updated) async {
                      await deviceService.writeMeasProcStandartization(
                        updated,
                        standIndex,
                        measProcIndex,
                        device,
                      );
                    },
                    onStart: () async {
                      await deviceService.makeStandartization(
                        stand,
                        standIndex,
                        measProcIndex,
                        device,
                      );
                    },
                    onStop: () async {
                      await deviceService.switchMeasState(false, device);
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
