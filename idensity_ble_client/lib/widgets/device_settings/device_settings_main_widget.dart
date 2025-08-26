import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';

class DeviceSettingsMainWidget extends ConsumerWidget {
  const DeviceSettingsMainWidget(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceService = ref.watch(deviceServiceProvider);

    return SafeArea(
      child: StreamBuilder(
        stream: deviceService.devicesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            if (data.isNotEmpty) {
              return Column(
                children: [
                  Expanded(child: child),
                  Focus(
                    autofocus: true,
                    child: SizedBox(
                      height: 80,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (value) {
                          if(value < data.length){
                            final newDevice = data[value];
                            ref.read(selectedDeviceIdProvider.notifier).state = newDevice.name;
                          }
                        },
                        itemCount: deviceService.devices.length,
                        itemBuilder: (context, index) {
                          final device = deviceService.devices[index];
                    
                          return Card(child: Center(child: Text(device.name)), );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
