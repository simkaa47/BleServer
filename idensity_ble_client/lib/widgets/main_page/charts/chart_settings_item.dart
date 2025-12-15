import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/services/charts/charts_settings_service.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/add_edit_chart_settings_item_widget.dart';

class ChartSettingsItem extends StatefulWidget {
  const ChartSettingsItem({
    super.key,
    required this.settingsService,
    required this.settings, 
    required this.deviceService,
  });

  final ChartsSettingsService settingsService;
  final ChartSettings settings;
  final DeviceService deviceService;

  @override
  State<ChartSettingsItem> createState() => _ChartSettingsItemState();
}

class _ChartSettingsItemState extends State<ChartSettingsItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(        
        onLongPress: () {
          showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return AddEditChartSettingsItemWidget(
                      chartSettings: widget.settings,
                      deviceNames:
                          widget.deviceService.devices.map((d) => d.name).toList(),
                      onSave: (s) async {
                        await widget.settingsService.editSettings(s);
                      },
                    );
                  },
                );
        },
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
