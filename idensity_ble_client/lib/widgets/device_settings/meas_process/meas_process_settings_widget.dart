import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

const _titles = {
  Routes.measProcDeviceSettings: "Измерительные процессы",
  Routes.measProcFastChangeSettings: "Измерительные процессы - Настройки быстрых изменений",
  Routes.measProcStandSettings: "Измерительные процессы - Данные стандартизаций",
  Routes.measProcCalibrCurve: "Измерительные процессы - Кривая калибровки",
   Routes.measProcCalibration: "Измерительные процессы - Калибровка",
};

class MeasProcessSettingsWidget extends ConsumerWidget {
  const MeasProcessSettingsWidget(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = GoRouterState.of(context).uri.path;
    final title = _titles[path] ?? "Измерительные процессы";
    final isNested = path != Routes.measProcDeviceSettings;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: isNested ? BackButton(onPressed: () => context.pop()) : null,
      ),
      body: Column(
        children: [
          Expanded(child: child),
          Focus(
            autofocus: true,
            child: SizedBox(
              height: 80,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                onPageChanged: (value) {
                  if (value < Device.measProcCnt) {
                    ref.read(selectedMeasProcIndexProvider.notifier).state =
                        value;
                  }
                },
                itemCount: Device.measProcCnt,
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
