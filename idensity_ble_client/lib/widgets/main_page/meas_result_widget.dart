// lib/widgets/main_page/meas_result_widget.dart
// Rewritten to match the "Плотность" block from the mock:
//  - card with outline
//  - section label ("Плотность") in muted small caps
//  - averaged value: large, primary teal, tabular figures
//  - instantaneous value: medium, neutral dark
//  - DropdownButton for measUnit, styled inline on the right

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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final measUnitServiceValue = ref.read(measUnitServiceProvider);
    final selectMeasUnitsAsyncValue =
        ref.watch(changeMeasUnitSelectingProvider);
    if (!(selectMeasUnitsAsyncValue.hasValue &&
        measUnitServiceValue.hasValue)) {
      return const Center(child: Text("No info about meas units"));
    }

    final measUnitService = measUnitServiceValue.value;

    return StreamBuilder(
      stream: device.settingsStream,
      builder: (context, snapshot) {
        final devMode = snapshot.data?.deviceMode.index ?? 0;
        final measType =
            snapshot.data?.measProcesses[result.measProcIndex].measType ?? 0;
        final measUnits =
            measUnitService!.getMeasUnitsForMeasProc(measType, devMode);
        final measUnit =
            measUnitService.getMeasUnitForMeasProc(measType, devMode);
        final koeff = measUnit?.coeff ?? 1;
        final offset = measUnit?.offset ?? 0;
        final title = getByIndexFromList(
          measType,
          devMode == 0 ? densityMeasModes : levelmeterMeasModes,
        );

        final avg = (result.averageValue * koeff + offset).toStringAsFixed(3);
        final cur = (result.currentValue * koeff + offset).toStringAsFixed(3);

        return Card(
          margin: const EdgeInsets.all(4),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section label + meas-unit dropdown row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: tt.titleSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<MeasUnit>(
                        value: measUnit,
                        isDense: true,
                        iconEnabledColor: cs.onSurfaceVariant,
                        items: measUnits
                            .map(
                              (item) => DropdownMenuItem<MeasUnit>(
                                value: item,
                                child: MeasUnitItemWidget.getFormula(
                                  item.name,
                                  fontSize: 16,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (newValue) async {
                          if (newValue != null) {
                            await measUnitService.changeMeasUnit(newValue);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                // Averaged — primary, large
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          avg,
                          style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            color: cs.primary,
                            height: 1.0,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      Text(
                        "Усреднённое значение",
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),

                // Instantaneous — neutral, medium
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          cur,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurface,
                            height: 1.0,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                      Text(
                        "Мгновенное значение",
                        style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
