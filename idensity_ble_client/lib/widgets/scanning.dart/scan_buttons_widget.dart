import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/scan_result.dart';
import 'package:idensity_ble_client/models/scan_state.dart';
import 'package:idensity_ble_client/services/scan_service.dart';

class ScanButtonsWidget extends StatelessWidget {
  const ScanButtonsWidget({super.key, required this.scanService, required this.selectedResults});

  final ScanService scanService;
  final List<IdensityScanResult> selectedResults;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: scanService.scanState,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          final state = snapshot.data;
          if (state == ScanState.notSupported || state == ScanState.off) {
            return const SizedBox.shrink();
          } else if (state != ScanState.scanning) {
            return FloatingActionButton(
              heroTag: 'start_scan',
              onPressed: () async {
                selectedResults.clear();
                await scanService.startScan(duration: 10);
              },
              child: const Icon(Icons.play_arrow),
            );
          } else {
            return FloatingActionButton(
              enableFeedback: false,
              heroTag: 'stop_scan',
              onPressed: () async {
                await scanService.stopScan();
              },
              child: const Icon(Icons.stop),
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
