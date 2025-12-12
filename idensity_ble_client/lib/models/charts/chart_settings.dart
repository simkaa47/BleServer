import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rightAxis': rightAxis ? 1 : 0,
      'color': color.toHexString(),
      'deviceName': deviceName,
      'chartType': chartType.index,
    };
  }

  static ChartSettings fromMap(Map<String, dynamic> map) {
    return ChartSettings(
      id: map['id'],
      rightAxis: map['rightAxis'] != 0,
      color: _getColorFromString(map['color']),
      deviceName: map['deviceName'],
      chartType: ChartType.values[map['chartType']],
    );
  }

  ChartSettings getCopy() {
    return ChartSettings(
      color: color,
      deviceName: deviceName,
      chartType: chartType,
      rightAxis: rightAxis,
    );
  }

  ChartSettings.withDefaults()
    : this(
        chartType: ChartType.counter,
        color: Colors.transparent,
        deviceName: "",
      );

  static _getColorFromString(
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
