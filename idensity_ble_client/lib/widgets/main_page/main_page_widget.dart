import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/indication.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';

class MainPageWidget extends ConsumerWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceService = ref.watch(deviceServiceProvider);

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: deviceService.devices.length,
        itemBuilder: (context, index) {
          final device = deviceService.devices[index];
          return Container(
            width: 300, // Задайте ширину, чтобы каждый элемент был виден
            child: StreamBuilder<IndicationData>(
              stream: device.dataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Column(
                    children: [
                      Text('Device ID: ${device.name}'),
                      Text('Temperature: ${data.temperature.toStringAsFixed(2)}'),
                      Text('HV: ${data.hv.toStringAsFixed(2)}'),
                      Text('Counters: ${data.counters.toStringAsFixed(1)}'),
                    ],
                  );
                } else {
                  return const Text('Waiting for data...');
                }
              },
            ),
          );
        },
      ),
    );
  }
}
