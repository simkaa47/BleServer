import 'package:flutter/material.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/main_chart.dart';
import 'package:idensity_ble_client/widgets/main_page/main_indication_widget.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final chart = const MainChart();
    final indication = const MainIndicationWidget();
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 1, child: chart),
              Expanded(
                flex: 1,
                child: Container(
                  // Нейтральная подложка для блока индикации.
                  // Если хочется лёгкий тёплый акцент — используйте
                  // colorScheme.tertiaryContainer (см. app_theme.dart).
                  color: Theme.of(context).colorScheme.surface,
                  child: indication,
                ),
              ),
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 1, child: chart),
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: indication,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
