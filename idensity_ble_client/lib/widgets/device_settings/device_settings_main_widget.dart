import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';

class DeviceSettingsMainWidget extends ConsumerWidget {
  const DeviceSettingsMainWidget(this.child, {super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceServiceAsyncState = ref.watch(deviceServiceProvider);
    final serviceName = "Сервис устройств";

    return deviceServiceAsyncState.when(
      data: (service) => _onDeviceServiceHasData(service, ref),
      error: (e, s) => UniversalAsyncHandler.onError(serviceName, e, s),
      loading: () => UniversalAsyncHandler.onLoading(serviceName),
    );
  }

  Widget _onDeviceServiceHasData(DeviceService deviceService, WidgetRef ref) {
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
                          if (value < data.length) {
                            final newDevice = data[value];
                            ref.read(selectedDeviceIdProvider.notifier).state =
                                newDevice.name;
                          }
                        },
                        itemCount: deviceService.devices.length,
                        itemBuilder: (context, index) {
                          final device = deviceService.devices[index];

                          return Card(
                            child: Center(
                              child: StreamBuilder<bool>(
                                stream: device.connectionStream,
                                initialData: device.isConnected,
                                builder: (context, snapshot) {
                                  final connected = snapshot.data ?? false;
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: connected ? Colors.green : Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(device.name),
                                    ],
                                  );
                                },
                              ),
                            ),
                          );
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
