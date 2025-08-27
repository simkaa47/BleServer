import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericParameterFloatingWidget extends StatefulWidget {
  const NumericParameterFloatingWidget({
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
  State<NumericParameterFloatingWidget> createState() {
    return _NumericParameterFloatingWidgetState();
  }
}

class _NumericParameterFloatingWidgetState
    extends State<NumericParameterFloatingWidget> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value.toString();
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
            TextFormField(
              decoration: InputDecoration(label: Text(widget.name)),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              controller: _controller,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите число';
                }
                final num? number = num.tryParse(value);

                if (number == null ||
                    number < widget.minValue ||
                    number > widget.maxValue) {
                  return 'Число должно быть в диапазоне от ${widget.minValue} до ${widget.maxValue}';
                }

                return null;
              },
              onChanged: (value) {
                _formKey.currentState?.validate();
              },
              onEditingComplete: () async {
                if (_formKey.currentState!.validate()) {
                  final newValue = num.tryParse(_controller.text);
                  if (newValue != null) {
                    await widget.onConfirm(newValue);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
