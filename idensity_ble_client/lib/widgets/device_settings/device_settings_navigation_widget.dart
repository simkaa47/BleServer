import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class DeviceSettingsNavigationWidget extends StatelessWidget {
  const DeviceSettingsNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children:  [
        Card(
          child: ListTile(
            title: const Text("Общие настройки"),
            leading: const Icon(Icons.settings),
            onTap: () {
              context.push(Routes.commonDeviceSettings);
            },
          ),
        ),
        const Card(
          child: ListTile(
            title: Text("Измерительные процессы"),
            leading: Icon(Icons.adjust_outlined),
          ),
        ),
        const Card(
          child: ListTile(
            title: Text("Счетчики"),
            leading: Icon(Icons.monitor_heart),
          ),
        ),
      ],
    );
  }
}
