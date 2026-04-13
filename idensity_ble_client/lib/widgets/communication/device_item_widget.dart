import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';

class DeviceItemWidget extends StatefulWidget {
  const DeviceItemWidget({super.key, required this.device});

  final Device device;

  @override
  State<StatefulWidget> createState() => _DeviceItemState();
}

class _DeviceItemState extends State<DeviceItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onLongPress: () {},
        title: Text("Имя устроства : ${widget.device.name}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.device.connectionSettings.connectionType ==
                ConnectionType.bluetooth)
              Text(
                "MAC: ${widget.device.connectionSettings.bluetoothSettings.macAddress}",
              ),
            if (widget.device.connectionSettings.connectionType ==
                ConnectionType.ethernet)
              Text(
                "IP: ${widget.device.connectionSettings.ethernetSettings.ip}",
              ),
          ],
        ),
        trailing: Container(
          margin: const EdgeInsets.all(4),
          child:
              widget.device.connectionSettings.connectionType ==
                      ConnectionType.bluetooth
                  ? const Icon(Icons.bluetooth)
                  : const Icon(Icons.settings_ethernet),
        ),
      ),
    );
  }
}
