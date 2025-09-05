import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication/meas_result.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/resources/enums.dart';

class MeasResultWidget extends ConsumerWidget {
  const MeasResultWidget(this.result, this.device, {super.key});
  final MeasResult result;
  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measUnitServiceValue = ref.read(measUnitServiceProvider);
    final selectMeasUnitsAsyncValue = ref.watch(
      changeMeasUnitSelectingProvider,
    );
    if (selectMeasUnitsAsyncValue.hasValue && measUnitServiceValue.hasValue) {
      final measUnitService = measUnitServiceValue.value;
      return StreamBuilder(
        stream: device.settingsStream,
        builder: (context, snapshot) {
          final devMode = snapshot.data?.deviceMode.index ?? 0;
          final measType =
              snapshot.data?.measProcesses[result.measProcIndex].measType ?? 0;
          final measUnits = measUnitService!.getMeasUnitsForMeasProc(
            measType,
            devMode,
          );
          final measUnit = measUnitService.getMeasUnitForMeasProc(
            measType,
            devMode,
          );
          return Card(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getByIndexFromList(
                          measType,
                          devMode == 0 ? densityMeasModes : levelmeterMeasModes,
                        ),
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
                ),
                DropdownButton(
                  value: measUnit?.name ?? "",
                  items:
                      measUnits
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (newValue) {},
                ),
              ],
            ),
          );
        },
      );
    }
    return const Center(child: Text("No info about meas units"));
  }
}
