import 'package:flutter/material.dart';
import 'package:idensity_ble_client/resources/platform.dart';
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
    this.actualValue,
    this.showCard = true,
  });

  final num? minValue;
  final num? maxValue;
  final num? actualValue;
  final String name;
  final num value;
  final Future<void> Function(num value) onConfirm;
  final int? fractionDigits;
  final bool showCard;

  _getSubtitle(num number) {
    return Text(
      fractionDigits != null
          ? number.toStringAsFixed(fractionDigits!)
          : number.toString(),
      style: TextStyle(
        color:
            (number > (maxValue ?? double.infinity) ||
                    number < (minValue ?? double.negativeInfinity))
                ? Colors.red
                : Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      title: Text(name),
      subtitle: Row(children: [
        if(actualValue != null)
         _getSubtitle(actualValue!),
        if(actualValue != null)
        const Text("/"),
        _getSubtitle(value)
        ]),
      onTap: () => _openInput(context),
    );
    return showCard ? Card(child: tile) : tile;
  }

  Future<void> _openInput(BuildContext context) async {
    if (kShowOsk) {
      final result = await showOskNum(
        context,
        name: name,
        initialValue: value,
        minValue: minValue,
        maxValue: maxValue,
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
              maxValue: maxValue,
              minValue: minValue,
              name: name,
              onConfirm: onConfirm,
              value: value,
              fractionDigits: fractionDigits,
            ),
      );
    }
  }
}
