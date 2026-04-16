import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/settings/device_mode.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/resources/platform.dart';
import 'package:idensity_ble_client/widgets/osk/osk_num_keyboard_widget.dart';
import 'package:idensity_ble_client/widgets/osk/osk_text_field.dart';

class AddEditMeasUnitWidget extends StatefulWidget {
  const AddEditMeasUnitWidget({
    super.key,
    required this.measUnitToSave,
    required this.onSaveMeasUnit,
  });
  final MeasUnit? measUnitToSave;

  final Future<void> Function(MeasUnit unit) onSaveMeasUnit;

  @override
  State<AddEditMeasUnitWidget> createState() {
    return _AddEditMeasUnitWidgetState();
  }
}

class _AddEditMeasUnitWidgetState extends State<AddEditMeasUnitWidget> {
  final _nameController = TextEditingController();
  final _coeffController = TextEditingController();
  final _offsetController = TextEditingController();
  int _selectedDeviceTypeIndex = 0;
  int _selecteMeasModeIndex = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedDeviceTypeIndex = widget.measUnitToSave?.deviceMode.index ?? 0;
    _selecteMeasModeIndex = widget.measUnitToSave?.measMode ?? 0;
    _nameController.text = widget.measUnitToSave?.name ?? "";
    _coeffController.text = widget.measUnitToSave?.coeff.toString() ?? 0.toString();
    _offsetController.text = widget.measUnitToSave?.offset.toString() ?? 0.toString();
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final measUnit = widget.measUnitToSave ?? MeasUnit.withDefaults();
      measUnit.measMode = _selecteMeasModeIndex;
      measUnit.deviceMode = DeviceMode.values[_selectedDeviceTypeIndex];
      measUnit.name = _nameController.text;
      measUnit.coeff = double.tryParse(_coeffController.text) ?? 0;
      measUnit.offset = double.tryParse(_offsetController.text) ?? 0;
      try {
        await widget.onSaveMeasUnit(measUnit);
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

  String? _numberValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'Введите число';
    }
    if (double.tryParse(input) == null) {
      return 'Некорректное число';
    }
    return null;
  }

  Widget _buildNumericField({
    required TextEditingController controller,
    required String label,
  }) {
    if (!kShowOsk) {
      return TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: _numberValidator,
        decoration: InputDecoration(label: Text(label)),
      );
    }
    return GestureDetector(
      onTap: () async {
        final initial = double.tryParse(controller.text) ?? 0;
        final result = await showOskNum(
          context,
          name: label,
          initialValue: initial,
          minValue: -1000000,
          maxValue: 1000000,
          isInteger: false,
        );
        if (result != null) {
          setState(() => controller.text = result.toString());
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: _numberValidator,
          decoration: InputDecoration(label: Text(label)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              OskFormField(
                controller: _nameController,
                label: 'Название',
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildNumericField(
                      controller: _coeffController,
                      label: 'Коэффициент',
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: _buildNumericField(
                      controller: _offsetController,
                      label: 'Смещение',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: getByIndexFromList(_selectedDeviceTypeIndex, devicesTypes),
                items:
                    devicesTypes
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
                      _selectedDeviceTypeIndex = devicesTypes.indexOf(value);
                    }
                  });
                },
                decoration: const InputDecoration(label: Text("Тип прибора")),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value:
                    (_selectedDeviceTypeIndex == 0
                        ? densityMeasModes
                        : levelmeterMeasModes)[_selecteMeasModeIndex],
                items:
                    (_selectedDeviceTypeIndex == 0
                            ? densityMeasModes
                            : levelmeterMeasModes)
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
                      _selecteMeasModeIndex = (_selectedDeviceTypeIndex == 0
                              ? densityMeasModes
                              : levelmeterMeasModes)
                          .indexOf(value);
                    }
                  });
                },
                decoration: const InputDecoration(label: Text("Тип измерения")),
              ),
      
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

  @override
  void dispose() {
    _coeffController.dispose();
    _nameController.dispose();
    _offsetController.dispose();
    super.dispose();
  }
}
