import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/models/scan_result.dart';
import 'package:idensity_ble_client/widgets/routes.dart';
import 'package:idensity_ble_client/widgets/scanning/scan_buttons_widget.dart';
import 'package:idensity_ble_client/widgets/scanning/scan_list.dart';

class ScanMainWidget extends ConsumerStatefulWidget {
  const ScanMainWidget({super.key});

  @override
  ConsumerState<ScanMainWidget> createState() {
    return _ScanMainState();
  }
}

class _ScanMainState extends ConsumerState<ScanMainWidget> {
  bool _selectedResultsIsNotEmpty = false;
  final List<IdensityScanResult> selectedResults = [];
  @override
  Widget build(BuildContext context) {
    final currentScanType = ref.watch(connectionTypeProvider);
    final scanTypeController = ref.watch(connectionTypeProvider.notifier);
    final scanService = ref.watch(scanServiceProvider(currentScanType));

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
      body: ScanList(
        scanService: scanService,
        selectedResults: selectedResults,
        onChangeSelectResults: () {
          setState(() {
            _selectedResultsIsNotEmpty = selectedResults.isNotEmpty;
          });
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ScanButtonsWidget(
            scanService: scanService,
            selectedResults: selectedResults,
            onStartScan: () {
              setState(() {
                _selectedResultsIsNotEmpty = selectedResults.isNotEmpty;
              });
            },
          ),
          const SizedBox(width: 16),
          Opacity(
            opacity: _selectedResultsIsNotEmpty ? 1 : 0.4,
            child: FloatingActionButton(
              heroTag: 'save device',
              onPressed:
                  _selectedResultsIsNotEmpty
                      ? () {
                        scanService.saveDevices(selectedResults);
                      }
                      : null,
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'next',
            onPressed: () async{
              await scanService.stopScan();
              if (!context.mounted) return;
              context.go(Routes.home);
            },
            child: const Icon(Icons.skip_next),
          ),
        ],
      ),
    );
  }
}
