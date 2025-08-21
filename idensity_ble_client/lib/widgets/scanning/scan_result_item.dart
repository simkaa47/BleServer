import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/scan_result.dart';

class ScanResultItem extends StatefulWidget {
  final IdensityScanResult result;
  final List<IdensityScanResult> selectedItems;

  const ScanResultItem({
    super.key,
    required this.result,
    required this.selectedItems,
    required this.onChangeSelectResults,
  });

  final Function() onChangeSelectResults;

  @override
  State<ScanResultItem> createState() => _ScanResultItemState();
}

class _ScanResultItemState extends State<ScanResultItem> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final isBle = widget.result is BlueScanResult;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        selected: _isSelected,
        selectedTileColor: Colors.blue.withAlpha(80),
        leading: isBle ? const Icon(Icons.bluetooth) : const Icon(Icons.wifi),
        title: Text(
          isBle
              ? (widget.result as BlueScanResult).advName
              : (widget.result as EthernetScanResult).ip,
        ),
        subtitle: Text(widget.result.macAddress),
        onTap: () {
          setState(() {
            if (widget.selectedItems.contains(widget.result)) {
              widget.selectedItems.remove(widget.result);
              _isSelected = false;
              
            } else {
              widget.selectedItems.add(widget.result);
              _isSelected = true;
            }
          });
          widget.onChangeSelectResults();
        },
      ),
    );
  }
}
