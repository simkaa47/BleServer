import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/device.dart';

class CommonSettingsWidget extends StatelessWidget {
  const CommonSettingsWidget({super.key, required this.device});

  final Device device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AppBar(title: const Text("Общие настройки")));
  }

}