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
    if (left.isEmpty && right.isEmpty) return const SizedBox.shrink();

    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Левая ось — выравнивание влево
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: left
                  .map((l) => _LegendItem(
                        line: l,
                        textColor: cs.onSurfaceVariant,
                        rightAlign: false,
                      ))
                  .toList(),
            ),
          ),
          // Правая ось — выравнивание вправо
          if (right.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: right
                    .map((l) => _LegendItem(
                          line: l,
                          textColor: cs.onSurfaceVariant,
                          rightAlign: true,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.line,
    required this.textColor,
    required this.rightAlign,
  });

  final ChartLine line;
  final Color textColor;
  final bool rightAlign;

  @override
  Widget build(BuildContext context) {
    final marker = Container(
      width: 12,
      height: 4,
      decoration: BoxDecoration(
        color: line.color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
    final unitWidget = line.measUnit != null
        ? MeasUnitItemWidget.getFormula(line.measUnit!.name, fontSize: 11, color: textColor)
        : null;

    // Text.rich инлайнит маркер + название + единицу в один поток.
    // Когда текст переносится — единица идёт сразу за последним словом,
    // а не уезжает к правому краю.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 11.5,
            color: textColor,
            height: 1.25,
            fontWeight: FontWeight.w500,
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: marker,
              ),
            ),
            TextSpan(text: _getLineName(line)),
            if (unitWidget != null) ...[              
              const TextSpan(text: '\u00A0'),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: unitWidget,
              ),
            ],
          ],
        ),
        textAlign: rightAlign ? TextAlign.right : TextAlign.left,
      ),
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



