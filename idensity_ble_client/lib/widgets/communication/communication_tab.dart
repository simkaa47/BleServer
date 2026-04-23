import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/widgets/async_state_handlers/universal_async_handler.dart';
import 'package:idensity_ble_client/widgets/communication/device_item_widget.dart';
import 'package:idensity_ble_client/widgets/routes.dart';

class CommunicationTab extends ConsumerStatefulWidget {
  const CommunicationTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommunicationTabState();
}

class _CommunicationTabState extends ConsumerState {
  
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref.read(appBarActionsProvider.notifier).state = [
        IconButton(icon: const Icon(Icons.scanner_rounded), onPressed: () {
          context.go(Routes.scanning);
        }, tooltip: "Сканировать",),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {   
    final deviceServiceAsyncState = ref.watch(deviceServiceProvider);
    final serviceName = "Сервис устройств";

    return deviceServiceAsyncState.when(
      data: (deviceService) => _onHasDeviceService(deviceService),
      error: (e, s) => UniversalAsyncHandler.onError(serviceName, e, s),
      loading: () => UniversalAsyncHandler.onLoading(serviceName),
    );
  }

  Widget _onHasDeviceService(DeviceService deviceService) {
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
                onDismissed: (direction) async {
                  await _deleteDevice(deviceService, context, device);
                },
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

  Future<void> _deleteDevice(
    DeviceService deviceService,
    BuildContext context,
    Device device,
  ) async {
    try {
      await deviceService.removeDevice(device);
      if (context.mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            persist: false,
            content: const Text("Данные удалены"),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: "Отменить",
              onPressed: () async {
                await deviceService.addDevices([device]);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("Ошибка  - $e"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
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
