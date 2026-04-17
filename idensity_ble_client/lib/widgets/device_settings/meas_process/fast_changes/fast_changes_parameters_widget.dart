import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/fast_change.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';

class FastChangesParametersWidget extends ConsumerWidget {
  const FastChangesParametersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measProcIndex = ref.watch(selectedMeasProcIndexProvider);
    final device = ref.watch(selectedDeviceProvider);
    final deviceServiceAsyncState = ref.watch(deviceServiceProvider);

    final serviceName = "Сервис устройств";

    return deviceServiceAsyncState.when(
      data: (service) => _onDeviceServiceData(device, measProcIndex, service),
      error: (e, s) => UniversalAsyncHandler.onError(serviceName, e, s),
      loading: () => UniversalAsyncHandler.onLoading(serviceName),
    );
  }

  Widget _onDeviceServiceData(
    Device? device,
    int measProcIndex,
    DeviceService deviceService,
  ) {
    return device != null
        ? StreamBuilder(
          stream: device.settingsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
              final measProc = snapshot.data?.measProcesses[measProcIndex];
              if (measProc != null) {
                return ListView(
                  children: [
                    TextParameterWidget(
                      minValue: 0,
                      maxValue: 100,
                      name: "Порог изменений, %",
                      value: measProc.fastChange.threshold,
                      onConfirm: (value) async {
                        final copy = _getCopyFastChange(measProc.fastChange);
                        copy.threshold = value.toInt();
                        await deviceService.writeFastChanges(
                          copy,
                          measProcIndex,
                          device,
                        );
                      },
                    ),
                    ComboboxParameterWidget(
                      name: "Активность",
                      value: measProc.fastChange.isActive ? 1 : 0,
                      onConfirm: (value) async {
                        final copy = _getCopyFastChange(measProc.fastChange);
                        copy.isActive = value != 0;
                        await deviceService.writeFastChanges(
                          copy,
                          measProcIndex,
                          device,
                        );
                      },
                      options: const ['Неактивен', "Активен"],
                    ),
                  ],
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          },
        )
        : const Text("Ожидание данных");
  }

  FastChange _getCopyFastChange(FastChange from) {
    FastChange copy = FastChange();
    copy.isActive = from.isActive;
    copy.threshold = from.threshold;
    return copy;
  }
}
