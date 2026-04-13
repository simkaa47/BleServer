import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication/meas_result.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/widgets/meas_units/meas_unit_item_widget.dart';

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
          final koeff = measUnit?.coeff ?? 1;
          final offset = measUnit?.offset ?? 0;
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
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    (result.averageValue * koeff + offset).toStringAsFixed(3),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Text(
                                "Усредненное значение",
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    (result.currentValue * koeff + offset).toStringAsFixed(3),
                                  ),
                                ),
                              ),
                              const Text(
                                "Мгновенное значение",
                                style: TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                DropdownButton(
                  value: measUnit,
                  items:
                      measUnits
                          .map(
                            (item) => DropdownMenuItem<MeasUnit>(
                              value: item,                              
                              child: MeasUnitItemWidget.getFormula(item.name, fontSize: 20)
                            ),
                          )
                          .toList(),
                  onChanged: (newValue) async {
                    if (newValue != null) {
                      await measUnitService.changeMeasUnit(newValue);
                    }
                  },
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
