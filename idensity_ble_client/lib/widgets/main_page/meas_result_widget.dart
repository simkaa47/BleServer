import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication/meas_result.dart';
import 'package:idensity_ble_client/resources/enums.dart';

class MeasResultWidget extends ConsumerWidget {
  const MeasResultWidget(this.result, this.device, {super.key});
  final MeasResult result;
  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: device.settingsStream,
            builder: (context, snapshot) {
              final devMode = snapshot.data?.deviceMode.index ?? 0;
              final measType =
                  snapshot.data?.measProcesses[result.measProcIndex].measType ??
                  0;
              return Text(
                getByIndexFromList(
                  measType,
                  devMode == 0 ? densityMeasModes : levelmeterMeasModes,
                ),
              );
            },
          ),
          Expanded(
            // Этот Expanded предоставит ограничения для ListTile
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: FittedBox(
                      // Заставляет дочерний элемент заполнить всё доступное пространство
                      fit:
                          BoxFit
                              .contain, // Масштабирует содержимое так, чтобы оно поместилось, сохраняя пропорции
                      child: AutoSizeText(
                        result.averageValue.toStringAsFixed(3),
                        // maxLines: 1, // Можно убрать, если FittedBox используется
                      ),
                    ),
                  ),
                  const Text(
                    "Усредненное значение",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            // Этот Expanded предоставит ограничения для ListTile
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: FittedBox(
                      // Заставляет дочерний элемент заполнить всё доступное пространство
                      fit:
                          BoxFit
                              .contain, // Масштабирует содержимое так, чтобы оно поместилось, сохраняя пропорции
                      child: AutoSizeText(
                        result.currentValue.toStringAsFixed(3),
                        // maxLines: 1, // Можно убрать, если FittedBox используется
                      ),
                    ),
                  ),
                  const Text(
                    "Мгновенное значение",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
