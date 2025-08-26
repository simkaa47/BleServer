import 'package:flutter/material.dart';

class ComboboxFloatingWidget extends StatefulWidget {
  const ComboboxFloatingWidget({
    super.key,
    required this.itemsSource,
    required this.value,
    required this.onConfirm,
    required this.paramName,
  });
  final int value;
  final Future Function(int value) onConfirm;
  final String paramName;

  final List<String> itemsSource;

  @override
  State<ComboboxFloatingWidget> createState() {
    return _ComboboxFloatingWidgetState();
  }
}

class _ComboboxFloatingWidgetState extends State<ComboboxFloatingWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField(
              value:
                  widget.itemsSource.length > widget.value
                      ? widget.itemsSource[widget.value]
                      : null,
              validator: (value) {
                if (value == null) {
                  return 'Текущее значение вне диапазона';
                }
                return null;
              },
              items:
                  widget.itemsSource
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              decoration: InputDecoration(label: Text(widget.paramName)),

              onChanged: (value) async {
                if (value != null) {
                  final index = widget.itemsSource.indexOf(value);
                  await widget.onConfirm(index);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
