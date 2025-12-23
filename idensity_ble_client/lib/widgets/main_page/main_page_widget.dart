import 'package:flutter/material.dart';
import 'package:idensity_ble_client/widgets/main_page/charts/main_real_time_widget.dart';
import 'package:idensity_ble_client/widgets/main_page/main_indication_widget.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final chart = const MainRealTimeWidget();
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
                  color: Colors.yellow.withOpacity(0.2),
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
                  color: Colors.yellow.withOpacity(0.2),
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
