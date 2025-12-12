import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorFormField extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final String labelText;
  final String? hintText;

  const ColorFormField({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
    required this.labelText,
    this.hintText,
  });

  // Внутренняя функция для показа палитры
  void _showColorPicker(BuildContext context) {
    Color tempColor = initialColor; // Временное хранилище цвета

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(labelText),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: initialColor,
            onColorChanged: (color) {
              tempColor = color; // Обновляем временный цвет
            },
            enableAlpha: true,
            paletteType: PaletteType.hsv,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('ОТМЕНА'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('ВЫБРАТЬ'),
            onPressed: () {
              onColorChanged(tempColor); // Сохраняем выбранный цвет
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Создаем InkWell для обработки нажатия на поле
    return InkWell(
      onTap: () => _showColorPicker(context),
      child: InputDecorator(
        decoration: InputDecoration(
          // 2. Используем labelText для подписи над полем
          labelText: labelText,
          // Используем hintText для текста внутри, если цвет не выбран (хотя у нас всегда есть initialColor)
          hintText: hintText, 
          // Добавляем иконку, чтобы поле выглядело как поле ввода/выбора
          suffixIcon: const Icon(Icons.colorize), 
          // Можно добавить рамку (border)
          border: const UnderlineInputBorder(),
        ),
        // 3. Главный контент поля - индикатор цвета
        isEmpty: false, // Всегда false, так как у нас всегда есть цвет
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // Визуальный индикатор текущего цвета
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: initialColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade400),
                ),
              ),
              const SizedBox(width: 12),
              // Вывод HEX-кода цвета
              Text(
                '#${initialColor.toHexString()}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}