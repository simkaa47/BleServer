// lib/widgets/main_page/indication_item_widget.dart
// Rewritten to match the mock: card with outline, accent icon,
// secondary label, primary-coloured tabular value.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class IndicationItemWidget extends StatelessWidget {
  const IndicationItemWidget({
    super.key,
    required this.paramName,
    required this.value,
    this.icon,
  });

  final String paramName;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: cs.primary, size: 22),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: AutoSizeText(
                      paramName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                        color: cs.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      minFontSize: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: AutoSizeText(
                      value,
                      style: TextStyle(
                        color: cs.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        height: 1.1,
                      ),
                      maxLines: 1,
                      minFontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
