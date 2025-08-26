import 'package:flutter/material.dart';
import 'package:idensity_ble_client/widgets/parameters/combobox_floating_widget.dart';

class ComboboxParameterWidget extends StatelessWidget {
  const ComboboxParameterWidget({
    super.key,
    required this.name,
    required this.value,
    required this.onConfirm,
    required this.options,
  });

  final String name;
  final int value;
  final Future Function(int value) onConfirm;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle:
            (options.length > value)
                ? Text(options[value])
                : const Text(
                  "Вне диапазона",
                  style: TextStyle(color: Colors.red),
                ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return ComboboxFloatingWidget(
                itemsSource: options,
                paramName: name,
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
