import 'package:flutter/material.dart';
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
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return NumericParameterFloatingWidget(
                maxValue: maxValue,
                minValue: minValue,
                name: name,
                onConfirm: onConfirm,
                value: value,
              );
            },
          );
        },
      ),
    );
  }
}
