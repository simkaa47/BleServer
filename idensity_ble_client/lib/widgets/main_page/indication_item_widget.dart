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
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 216, 214, 210),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: AutoSizeText(
                      paramName,
                      style: const TextStyle(fontSize: 18),
                      maxLines: 2,
                      maxFontSize: 18,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    child: AutoSizeText(
                      value,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 1, 63, 50),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      maxFontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
