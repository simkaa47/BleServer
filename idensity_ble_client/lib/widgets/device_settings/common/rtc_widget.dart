import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/services/device_service.dart';

class RtcWidget extends StatelessWidget {
  const RtcWidget({
    super.key,
    required this.device,
    required this.deviceService,
  });

  final Device device;
  final DeviceService deviceService;

  String _format(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}  '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: device.dataStream,
      builder: (context, snapshot) {
        final rtc = snapshot.data?.rtc;
        return Card(
          child: ListTile(
            title: const Text('RTC'),
            subtitle: Text(rtc != null ? _format(rtc) : '—'),
            trailing: IconButton(
              icon: const Icon(Icons.sync),
              tooltip: 'Синхронизировать с системным временем',
              onPressed: () => deviceService.writeRtc(DateTime.now(), device),
            ),
          ),
        );
      },
    );
  }
}
