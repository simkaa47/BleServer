import 'package:drift/drift.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:idensity_ble_client/data_access/app_database.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';

extension ChartSettingToCompanion on ChartSettings {
  ChartSettingTableRowsCompanion toCompanion() {
    return ChartSettingTableRowsCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      color: Value(color.toHexString()),
      deviceName: Value(deviceName),
      rightAxis: Value(rightAxis),
      chartType: Value(chartType.index),
    );
  }
}

extension ChartSettingFromRow on ChartSettingTableRow {
  ChartSettings toModel() {
    return ChartSettings(
      color: ChartSettings.getColorFromString(color),
      deviceName: deviceName,
      chartType: ChartType.values[chartType],
      id: id,
      rightAxis: rightAxis,
    );
  }
}
