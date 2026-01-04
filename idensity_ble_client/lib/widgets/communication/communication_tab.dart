import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/communication/device_item_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class CommunicationTab extends ConsumerWidget {
  const CommunicationTab({super.key});

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
                      context.go(Routes.scanning);
                    },
                    iconSize: 100,
                    icon: const Icon(Icons.add_circle_rounded),
                  ),
                  const Text("Добавьте устройство для получения данных"),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              final device = data[index];
              return Dismissible(
                background: _getBackground(DismissDirection.startToEnd),
                secondaryBackground: _getBackground(
                  DismissDirection.endToStart,
                ),
                key: ValueKey(data[index]),
                child: DeviceItemWidget(device: device),
                onDismissed: (direction) async {},
              );
            },
          );
        } else {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text("Ожидание данных устройств"),
              ],
            ),
          );
          ;
        }
      },
    );
  }

  Widget _getBackground(DismissDirection direction) {
    return Container(
      color: Colors.red,
      alignment:
          direction == DismissDirection.startToEnd
              ? Alignment.centerLeft
              : Alignment.centerRight,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }
}
