import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/scan_result.dart';

class ScanResultItem extends StatelessWidget {
  final IdensityScanResult result;

  const ScanResultItem({super.key, required this.result}); 
  

  @override
  Widget build(BuildContext context) {
    final isBle = result is BlueScanResult;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: isBle ? const Icon(Icons.bluetooth) : const Icon(Icons.wifi),
        title: Text(result.macAddress),
        subtitle: const Text('Нажмите, чтобы подключиться'),
        onTap: () {
          // Здесь можно добавить логику для подключения к устройству
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Попытка подключения к $result.macAddress')),
          );
        },
      ),
    );
  }
  
}