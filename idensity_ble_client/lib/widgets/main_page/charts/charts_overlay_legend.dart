import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/charts/chart_line.dart';

class ChartsOverlayLegend extends StatelessWidget {
  const ChartsOverlayLegend({super.key, required this.lines});

  final List<ChartLine> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(160),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
      ),
      child: _buildLegendColumn(),
    );
  }

  Widget _buildLegendColumn() {
    if (lines.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        ...lines.map((line) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: line.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(line.id, style: const TextStyle(fontSize: 11)),
              ],
            ),
          );
        }),
      ],
    );
  }
}
