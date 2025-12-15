import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/widgets/colors/color_form_field.dart';

class AddEditChartSettingsItemWidget extends StatefulWidget {
  const AddEditChartSettingsItemWidget({
    super.key,
    required this.deviceNames,
    this.chartSettings,
    required this.onSave,
  });

  final List<String> deviceNames;
  final ChartSettings? chartSettings;
  final Future<void> Function(ChartSettings settings) onSave;

  @override
  State<AddEditChartSettingsItemWidget> createState() =>
      _AddEditChartSettingsItemWidgetState();
}

class _AddEditChartSettingsItemWidgetState
    extends State<AddEditChartSettingsItemWidget> {
  final _formKey = GlobalKey<FormState>();
  String? _deviceName;
  ChartType _chartType = ChartType.counter;
  bool _isRightAxis = false;
  Color _selectedColor = Colors.transparent;

  static const List<String> _axis = ["Левая", "Правая"];

  @override
  void initState() {
    super.initState();
    _deviceName = widget.chartSettings?.deviceName;
    _chartType = widget.chartSettings?.chartType ?? ChartType.counter;
    _isRightAxis = widget.chartSettings?.rightAxis ?? false;
    _selectedColor = widget.chartSettings?.color ?? Colors.transparent;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final settings = widget.chartSettings ?? ChartSettings.withDefaults();
      settings.deviceName = _deviceName ?? "";
      settings.chartType = _chartType;
      settings.rightAxis = _isRightAxis;
      settings.color = _selectedColor;
      try {
        await widget.onSave(settings);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Данные сохранены!')));
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ошибка сохранения в базу данных!',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceNamesItems =
        widget.deviceNames
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            )
            .toList();
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              DropdownButtonFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите ID прибора';
                  }
                  return null;
                },

                initialValue:
                    widget.deviceNames.isEmpty ||
                            _deviceName == null ||
                            !widget.deviceNames.contains(_deviceName)
                        ? null
                        : _deviceName,
                items: deviceNamesItems,
                onChanged: (value) {
                  if (value != null) {
                    _deviceName = value;
                  }
                  _formKey.currentState?.validate();
                },
                decoration: const InputDecoration(label: Text("ID прибора")),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                initialValue: getByIndexFromList(_chartType.index, chartNames),
                items:
                    chartNames
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
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      final selectedIndex = chartNames.indexOf(value);
                      _chartType = ChartType.values.elementAt(selectedIndex);
                    }
                  });
                },
                decoration: const InputDecoration(label: Text("Тип кривой")),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                initialValue: getByIndexFromList(_isRightAxis ? 1 : 0, _axis),
                items:
                    _axis
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
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      final selectedIndex = chartNames.indexOf(value);
                      _isRightAxis = selectedIndex != 0;
                    }
                  });
                },
                decoration: const InputDecoration(label: Text("Ось Y")),
              ),
              const SizedBox(height: 20),
              ColorFormField(
                labelText: 'Цвет акцента',
                hintText: 'Выберите основной цвет',
                initialColor: _selectedColor,
                onColorChanged: (newColor) {
                  // Обновляем состояние при выборе нового цвета
                  setState(() {
                    _selectedColor = newColor;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Отмена"),
                  ),
                  ElevatedButton(
                    onPressed: _submitData,
                    child: const Text("Cохранить"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
