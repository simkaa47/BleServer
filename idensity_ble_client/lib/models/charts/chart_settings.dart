import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';

class ChartSettings {
  ChartSettings({
    this.id,    
    required this.color,
    required this.deviceName,
    required this.chartType,
    this.rightAxis = false,
  });

  int? id;
  bool rightAxis = false;
  Color color;
  String deviceName = "";
  ChartType chartType;  
 
  ChartSettings.withDefaults()
    : this(
        chartType: ChartType.counter,
        color: Colors.transparent,
        deviceName: "",
      );

  static getColorFromString(
    String hexColor, {
    Color defaultColor = Colors.transparent,
  }) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = hexColor;
    } else if (hexColor.length != 8) {
      // Неверная длина строки (не 6 и не 8 символов)
      debugPrint(
        'Ошибка: Неверный формат HEX-строки ($hexColor). Использую дефолтный цвет.',
      );
      return defaultColor;
    }
    final int? colorValue = int.tryParse(hexColor, radix: 16);

    if (colorValue == null) {
      // Парсинг не удался (строка содержала недопустимые HEX-символы)
      debugPrint(
        'Ошибка: Невозможно распарсить HEX-строку "$hexColor". Использую дефолтный цвет.',
      );
      return defaultColor;
    }

    return Color(colorValue);
  }
}
