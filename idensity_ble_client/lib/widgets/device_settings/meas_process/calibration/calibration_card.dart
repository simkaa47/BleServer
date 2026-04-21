import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class CalibrationCard extends StatelessWidget {
  const CalibrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text("Калибровка"),        
        onTap: () => context.push(Routes.measProcCalibration),
      ),
    );
  }

}