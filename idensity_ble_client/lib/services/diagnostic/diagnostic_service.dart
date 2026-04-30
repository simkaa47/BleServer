import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/diagnostic/device_event.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';

typedef ActiveEvent = ({String deviceName, DeviceEvent event});

abstract interface class DiagnosticService {
  void registerDevice(Device device);
  void unregisterDevice(Device device);
  void check(Device device, IndicationData indication);
  void updateConnectionEvent(Device device, bool connected);
  Stream<List<DeviceEvent>> eventsStreamFor(Device device);
  List<DeviceEvent> eventsFor(Device device);
  Stream<List<ActiveEvent>> get allActiveEventsStream;
}
