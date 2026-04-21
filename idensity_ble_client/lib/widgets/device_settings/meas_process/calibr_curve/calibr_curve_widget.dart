import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/calibr_curve.dart';
import 'package:idensity_ble_client/models/settings/calibration_type.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_parameter_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';

class CalibrCurveWidget extends ConsumerWidget {
  const CalibrCurveWidget({super.key});

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

  CalibrCurve _calibrCurveCopy(CalibrCurve curve) {
    final copy = CalibrCurve();
    copy.type = curve.type;
    for (int i = 0; i < curve.coefficients.length; i++) {
      copy.coefficients[i] = curve.coefficients[i];
    }
    return copy;
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
                    ComboboxParameterWidget(
                      name: "Тип калибровки",
                      value: measProc.calibrCurve.type.index,
                      onConfirm: (value) async {
                        await deviceService.writeMeasProcCalibrCurve(
                          _calibrCurveCopy(measProc.calibrCurve)
                            ..type = CalibrationType.values.elementAt(value),
                          measProcIndex,
                          device,
                        );
                      },
                      options: const [
                        "Плотность",
                        "Массовая концентрация фазы 1",
                        "Массовая концентрация фазы 2",
                        "None",
                      ],
                    ),
                    for (var (i, c) in measProc.calibrCurve.coefficients.indexed)
                      TextParameterWidget(
                        name: 'К-т $i',
                        value: c,
                        fractionDigits: 6,
                        onConfirm: (value) async {
                          await deviceService.writeMeasProcCalibrCurve(
                            _calibrCurveCopy(measProc.calibrCurve)
                              ..coefficients[i] = value.toDouble(),
                            measProcIndex,
                            device,
                          );
                        },
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
