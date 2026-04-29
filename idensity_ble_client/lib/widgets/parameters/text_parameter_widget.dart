import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/resources/platform.dart';
import 'package:idensity_ble_client/widgets/meas_units/meas_unit_item_widget.dart';
import 'package:idensity_ble_client/widgets/osk/osk_num_keyboard_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/numeric_parameter_floating_widget.dart';

class TextParameterWidget extends StatelessWidget {
  const TextParameterWidget({
    super.key,
    this.minValue,
    this.maxValue,
    required this.name,
    required this.value,
    required this.onConfirm,
    this.fractionDigits,
    this.measUnits,
    this.actualValue,
    this.selectedMeasNum,
    this.showCard = true,  
    this.onChangeMeasUnit,
  });

  final num? minValue;
  final num? maxValue;
  final num? actualValue;
  final MeasUnit? selectedMeasNum;
  final List<MeasUnit>? measUnits;  
  final String name;
  final num value;
  final Future<void> Function(num value) onConfirm;
  final Future<void> Function(MeasUnit measUnit)? onChangeMeasUnit;
  final int? fractionDigits;
  final bool showCard;

  _getSubtitle(num number) {
    final koeff = selectedMeasNum?.coeff ?? 1;
    final offset = selectedMeasNum?.offset ?? 0;
    final displayMax = maxValue != null ? maxValue! * koeff + offset : null;
    final displayMin = minValue != null ? minValue! * koeff + offset : null;
    return Text(
      fractionDigits != null
          ? number.toStringAsFixed(fractionDigits!)
          : number.toString(),
      style: TextStyle(
        color:
            (number > (displayMax ?? double.infinity) ||
                    number < (displayMin ?? double.negativeInfinity))
                ? Colors.red
                : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      title: Text(name),
      subtitle: Row(
        children: [
          if (actualValue != null) _getSubtitle(actualValue!),
          if (actualValue != null) const Text("/"),
          _getSubtitle(value),
        ],
      ),
      trailing: (measUnits != null && measUnits!.isNotEmpty)
          ? DropdownButton<MeasUnit>(
              value: selectedMeasNum,
              items: measUnits!
                  .map((u) => DropdownMenuItem<MeasUnit>(
                        value: u,
                        child: MeasUnitItemWidget.getFormula(u.name, fontSize: 16),
                      ))
                  .toList(),
              onChanged: (u) async {
                if (u != null) await onChangeMeasUnit?.call(u);
              },
            )
          : null,
      onTap: () => _openInput(context),
    );
    return showCard ? Card(child: tile) : tile;
  }

  Future<void> _openInput(BuildContext context) async {
    final koeff = selectedMeasNum?.coeff ?? 1;
    final offset = selectedMeasNum?.offset ?? 0;
    final displayMin = minValue != null ? minValue! * koeff + offset : null;
    final displayMax = maxValue != null ? maxValue! * koeff + offset : null;

    if (kShowOsk) {
      final result = await showOskNum(
        context,
        name: name,
        initialValue: value,
        minValue: displayMin,
        maxValue: displayMax,
        isInteger: value is int,
        fractionDigits: fractionDigits,
      );
      if (result != null) await onConfirm(result);
    } else {
      if (!context.mounted) return;
      showModalBottomSheet(
        context: context,
        builder:
            (ctx) => NumericParameterFloatingWidget(
              maxValue: displayMax,
              minValue: displayMin,
              name: name,
              onConfirm: onConfirm,
              value: value,
              fractionDigits: fractionDigits,
            ),
      );
    }
  }
}
