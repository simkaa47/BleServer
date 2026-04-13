import 'package:idensity_ble_client/models/device.dart';

abstract class DeviceRepository {
  Future<List<Device>> getDevicesList();
  Future<bool> delete(Device device);
  Future<int> add(Device device);
}