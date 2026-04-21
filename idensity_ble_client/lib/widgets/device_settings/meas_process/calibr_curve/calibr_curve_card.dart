import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/settings/calibr_curve.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class CalibrCurveCard extends StatelessWidget {
  const CalibrCurveCard({super.key, required this.curve});

  final CalibrCurve curve;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text("Калибровочная кривая"),        
        onTap: () => context.push(Routes.measProcCalibrCurve),
      ),
    );
  }

}
