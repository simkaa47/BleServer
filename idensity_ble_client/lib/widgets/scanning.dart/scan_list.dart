import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/scan_result.dart';
import 'package:idensity_ble_client/models/scan_state.dart';
import 'package:idensity_ble_client/services/scan_service.dart';
import 'package:idensity_ble_client/widgets/scanning.dart/scan_result_item.dart';

class ScanList extends StatelessWidget {
  const ScanList({
    super.key,
    required this.scanService,
    required this.selectedResults,
    required this.onChangeSelectResults,
  });

  final ScanService scanService;
  final Function() onChangeSelectResults;

  final List<IdensityScanResult> selectedResults;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                return ScanResultItem(
                  result: scanService.scanResults[index],
                  selectedItems: selectedResults,
                  onChangeSelectResults: onChangeSelectResults,
                );
              },
            );
          }
        }
        return Text('Ожидание состояния адаптера Bluetooth...');
      },
    );
  }
}
