import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';

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
            line.id,
            style: const TextStyle(fontSize: 11),
            textAlign: rightAlign ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}
