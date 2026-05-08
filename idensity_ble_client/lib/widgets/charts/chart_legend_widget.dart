import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/resources/enums.dart';
import 'package:idensity_ble_client/widgets/meas_units/meas_unit_item_widget.dart';

class ChartLegendWidget extends StatelessWidget {
  const ChartLegendWidget({super.key, required this.lines});

  final List<ChartLine> lines;

  @override
  Widget build(BuildContext context) {
    final left = lines.where((l) => !l.isRight).toList();
    final right = lines.where((l) => l.isRight).toList();
    if (left.isEmpty && right.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: left.map((l) => _item(l)).toList(),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: right.map((l) => _item(l, rightAlign: true)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(ChartLine line, {bool rightAlign = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          rightAlign ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: line.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            _getLineName(line),
            style: const TextStyle(fontSize: 11),
            textAlign: rightAlign ? TextAlign.right : TextAlign.left,
          ),
        ),
        if (line.measUnit != null) ...[
          const SizedBox(width: 4),
          MeasUnitItemWidget.getFormula(line.measUnit!.name, fontSize: 11),
        ],
      ],
    );
  }

  String _getLineName(ChartLine line) {
    if (line.measUnit != null) {
      switch (line.chartType) {
        case ChartType.averageValue0:
        case ChartType.currentValue0:
        case ChartType.averageValue1:
        case ChartType.currentValue1:
          final name =
              "${line.deviceName}:${getByIndexFromList(line.measUnit!.measMode, line.measUnit!.deviceMode.index == 0 ? densityMeasModes : levelmeterMeasModes)}";
          final valueType =
              line.chartType == ChartType.averageValue0 ||
                      line.chartType == ChartType.averageValue1
                  ? "усредн."
                  : "мгнов.";
          return '$name, $valueType';
        default:
      }
    }
    return line.id;
  }
}
