import 'package:idensity_ble_client/models/device.dart';

abstract interface class DeviceService {
  Stream<Device> get updateStream;
  Stream<List<Device>> get devicesStream;
  List<Device> get devices;

  Future<void> init();
  Future<void> addDevices(List<Device> newDevices);
  Future<void> removeDevice(Device device);

  Future<void> writeDeviceType(int type, Device device);
  Future<void> writeMeasDuration(double value, int measProcIndex, Device device);
  Future<void> writeAveragePoints(int value, int measProcIndex, Device device);
  Future<void> writeCalcType(int value, int measProcIndex, Device device);
  Future<void> writeMeasType(int value, int measProcIndex, Device device);

  void dispose();
}
