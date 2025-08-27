import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';

class MeasProcessParametersWidget extends ConsumerWidget {
  const MeasProcessParametersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceService = ref.read(deviceServiceProvider);
    final measProcIndex = ref.watch(selectedMeasProcIndexProvider);
    final device = ref.watch(selectedDeviceProvider);

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
                      minValue: 0.1,
                      maxValue: 1000,
                      name: "Время измерения, с",
                      value: measProc.measDuration,
                      onConfirm: (value) async {
                        await deviceService.writeMeasDuration(
                          value.toDouble(),
                          measProcIndex,
                          device,
                        );
                      },
                    ),
                    TextParameterWidget(
                      minValue: 1,
                      maxValue: 99,
                      name: "Количество точек измерения для усреднения",
                      value: measProc.averagePoints,
                      onConfirm: (value) async {
                        await deviceService.writeAveragePoints(
                          value.toInt(),
                          measProcIndex,
                          device,
                        );
                      },
                    ),
                    ComboboxParameterWidget(
                      name: "Тип измерения",
                      value: measProc.measType,
                      onConfirm: (value) async {
                        await deviceService.writeMeasType(
                          value,
                          measProcIndex,
                          device,
                        );
                      },
                      options:
                          snapshot.data?.deviceMode == DeviceMode.density
                              ? densityMeasModes
                              : levelmeterMeasModes,
                    ),
                    ComboboxParameterWidget(
                      name: "Тип расчета",
                      value: measProc.calcType,
                      onConfirm: (value) async {
                        await deviceService.writeCalcType(
                          value,
                          measProcIndex,
                          device,
                        );
                      },
                      options: calcTypes,
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
}
