import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class MainIndicationWidget extends ConsumerWidget {
  const MainIndicationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceService = ref.read(deviceServiceProvider);
    return StreamBuilder<List<Device>>(
      stream: deviceService.devicesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed(Routes.scanning);
                    },
                    iconSize: 100,
                    icon: Icon(Icons.add_circle_rounded),
                  ),
                  Text("Добавьте устройство для получения данных")
                ],
              ),
            );
          }
          return PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: deviceService.devices.length,
            itemBuilder: (context, index) {
              final device = deviceService.devices[index];
              return Center(
                child: StreamBuilder<IndicationData>(
                  stream: device.dataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return Column(
                        children: [
                          Text('Device ID: ${device.name}'),
                          Text(
                            'Temperature: ${data.temperature.toStringAsFixed(2)}',
                          ),
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
          );
        } else {
          return const Text('Waiting for data...');
        }
      },
    );
  }
}
