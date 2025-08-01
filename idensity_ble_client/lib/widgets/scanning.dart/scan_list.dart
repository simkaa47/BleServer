import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/widgets/scanning.dart/scan_result_item.dart';

import '../../models/scan_state.dart';

class ScanList extends ConsumerWidget {
  const ScanList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScanType = ref.watch(connectionTypeProvider);
    final scanTypeController = ref.read(connectionTypeProvider.notifier);
    final scanService = ref.read(scanServiceProvider(currentScanType));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Сканирование новых устройств"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<ConnectionType>(
              value: currentScanType,
              items: const [
                DropdownMenuItem(
                  value: ConnectionType.bluetooth,
                  child: Text('Bluetooth'),
                ),
                DropdownMenuItem(
                  value: ConnectionType.ethernet,
                  child: Text('Ethernet'),
                ),
              ],
              onChanged: (ConnectionType? newValue) {
                if (newValue != null) {
                  scanTypeController.state =
                      newValue; // Изменяем состояние провайдера
                }
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: scanService.scanState,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            final state = snapshot.data;
            if (state == ScanState.notSupported) {
              return Center(
                child: Text('Bluetooth не поддерживается на этом устройстве'),
              );
            } else if (state == ScanState.off) {
              return Center(child: Text('Bluetooth выключен'));
            } else {
              return ListView.builder(
                itemCount: scanService.scanResults.length,
                itemBuilder: (context, index) {
                  return ScanResultItem(result: scanService.scanResults[index]);
                },
              );
            }
          }
          return Text('Ожидание состояния адаптера Bluetooth...');
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'start_scan',
            onPressed: () async {
              // Передаем текущий тип сканирования в сервис
              await scanService.startScan(duration: 10);
            },
            child: const Icon(Icons.play_arrow),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'stop_scan',
            onPressed: () async {
              await scanService.stopScan();
            },
            child: const Icon(Icons.stop),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'save device',
            onPressed: () {},
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
