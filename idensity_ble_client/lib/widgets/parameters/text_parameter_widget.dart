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
  });

  final num minValue;
  final num maxValue;
  final String name;
  final num value;
  final Future<void> Function(num value) onConfirm;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(
          value.toString(),
          style: TextStyle(
            color:
                (value > maxValue || value < minValue)
                    ? Colors.red
                    : Colors.black,
          ),
        ),
        onTap: () => _openInput(context),
      ),
    );
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
        ),
      );
    }
  }
}
