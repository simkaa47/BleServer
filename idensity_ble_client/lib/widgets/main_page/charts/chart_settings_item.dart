import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/services/charts/charts_settings_service.dart';

class ChartSettingsItem extends StatefulWidget {
  const ChartSettingsItem({
    super.key,
    required this.service,
    required this.settings,
  });

  final ChartsSettingsService service;
  final ChartSettings settings;

  @override
  State<ChartSettingsItem> createState() => _ChartSettingsItemState();
}

class _ChartSettingsItemState extends State<ChartSettingsItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("Имя устроства : ${widget.settings.deviceName}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Тип кривой : ${getByIndexFromList(widget.settings.chartType.index, chartNames)}",
            ),
            Text("Ось : ${widget.settings.rightAxis ? "Правая" : "Левая"}"),
          ],
        ),
        trailing: Container(
          margin: const EdgeInsets.all(4),
          child: CircleAvatar(
            backgroundColor: widget.settings.color,
            maxRadius: 10,
          ),
        ),
      ),
    );
  }
}
