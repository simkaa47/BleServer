import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:idensity_ble_client/widgets/device_settings/meas_process/meas_process_parameters_widget.dart';

class MeasProcessSettingsWidget extends ConsumerWidget {
  const MeasProcessSettingsWidget({super.key});  

  @override
  Widget build(BuildContext context, WidgetRef ref) {    
    return Scaffold(
      appBar: AppBar(title: const Text("Измерительные процессы"),),
      body: Column(
        children: [
          const Expanded(child: MeasProcessParametersWidget()),
          Focus(
            autofocus: true,
            child: SizedBox(
              height: 80,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  if (value < DeviceSettings.measProcCount) {
                    ref.read(selectedMeasProcIndexProvider.notifier).state =
                        value;
                  }
                },
                itemCount: DeviceSettings.measProcCount,
                itemBuilder: (context, index) {
                  return Card(
                    child: Center(
                      child: Text("Измерительный процесс №${index + 1}"),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
