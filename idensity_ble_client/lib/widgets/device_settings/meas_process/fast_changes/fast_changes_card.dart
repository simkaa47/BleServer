import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/settings/fast_change.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class FastChangesCard extends StatelessWidget {
  const FastChangesCard({super.key, required this.fastChange});

  final FastChange fastChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text("Настройки быстрых изменений"),
        subtitle:
            !fastChange.isActive
                ? const Text("НЕАКТИВЕН")
                : const Text(
                  "АКТИВЕН",
                  style: TextStyle(color: Colors.lightGreen),
                ),
        onTap: () => context.push(Routes.measProcFastChangeSettings),
      ),
    );
  }
}
