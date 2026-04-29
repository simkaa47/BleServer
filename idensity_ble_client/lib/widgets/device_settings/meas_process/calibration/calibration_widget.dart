import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/device_settings/meas_process/calibration/single_meas_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/text_parameter_widget.dart';
import 'package:rxdart/rxdart.dart';

class CalibrationWidget extends ConsumerWidget {
  const CalibrationWidget({super.key});

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
    if (device == null) return const Text("Ожидание данных");

    return StreamBuilder(
      stream: Rx.combineLatest2(
        device.settingsStream,
        device.dataStream,
        (settings, indication) => (settings, indication),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
          final measProc = snapshot.data?.$1.measProcesses[measProcIndex];
          final measProcIndication =
              snapshot.data?.$2.measProcessIndications[measProcIndex];
          if (measProc != null && measProcIndication != null) {
            return ListView(
              children: [
                TextParameterWidget(
                  name: "Время ед. измерения, с",
                  maxValue: 999,
                  minValue: 1,
                  value: measProc.singleMeasTime,
                  onConfirm: (value) async {
                    await deviceService.writeMeasProcSingleMeasDuration(
                      value.toInt(),
                      measProcIndex,
                      device,
                    );
                  },
                ),
                for (var (i, r) in measProc.singleMeasResults.indexed)
                  Card(
                    child: SingleMeasWidget(
                      name: 'Ед. измерение $i',
                      result: r,
                      indication: measProcIndication.singleMeasureIndications[i],
                      device: device,
                      measProcIndex: measProcIndex,
                      onWrite: (updated) => deviceService.writeSingleMeasResult(
                        updated,
                        i,
                        measProcIndex,
                        device,
                      ),
                      onStart: () => deviceService.makeSingleMeasurement(
                        i,
                        measProcIndex,
                        device,
                      ),
                      onStop: () async {},
                    ),
                  ),
              ],
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
