import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/settings/stand_settings.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class StandSettingsCard extends StatelessWidget {
  const StandSettingsCard({super.key, required this.standSettings});

  final List<StandSettings> standSettings;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text("Данные стандартизации"),
        subtitle: Text(
          standSettings.length >= 2
              ? 'Фон: ${standSettings[0].halfLifeResult.toStringAsFixed(1)} имп., Источник: ${standSettings[1].halfLifeResult.toStringAsFixed(1)} имп.'
              : 'Нет данных',
        ),
        onTap: () => context.push(Routes.measProcStandSettings),
      ),
    );
  }
}
