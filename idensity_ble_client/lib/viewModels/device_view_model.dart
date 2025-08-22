import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/providers/services_registration.dart';
import 'package:idensity_ble_client/services/device_service.dart';

class DeviceViewModel extends Notifier<Device> {
  @override
  Device build() {
    final service = ref.watch(deviceServiceProvider);
    var stream = service.devicesStream;
  }

  

}