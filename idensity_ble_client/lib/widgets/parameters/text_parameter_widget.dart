import 'package:flutter/material.dart';
import 'package:idensity_ble_client/resources/platform.dart';
import 'package:idensity_ble_client/widgets/osk/osk_num_keyboard_widget.dart';
import 'package:idensity_ble_client/widgets/parameters/numeric_parameter_floating_widget.dart';

class TextParameterWidget extends StatelessWidget {
  const TextParameterWidget({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.name,
    required this.value,
    required this.onConfirm,
    this.fractionDigits,
    this.showCard = true,
  });

  final num minValue;
  final num maxValue;
  final String name;
  final num value;
  final Future<void> Function(num value) onConfirm;
  final int? fractionDigits;
  final bool showCard;

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      title: Text(name),
      subtitle: Text(
        fractionDigits != null
            ? value.toStringAsFixed(fractionDigits!)
            : value.toString(),
        style: TextStyle(
          color: (value > maxValue || value < minValue)
              ? Colors.red
              : Colors.black,
        ),
      ),
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
        builder: (ctx) => NumericParameterFloatingWidget(
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
