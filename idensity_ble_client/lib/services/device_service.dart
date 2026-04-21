import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/settings/calibr_curve.dart';
import 'package:idensity_ble_client/models/settings/fast_change.dart';
import 'package:idensity_ble_client/models/settings/stand_settings.dart';

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
  Future<void> writeFastChanges(FastChange fastChange, int measProcIndex, Device device);
  Future<void> writeMeasProcActivity(bool activity, int measProcIndex, Device device);
  Future<void> writeMeasProcStandartization(StandSettings stand, int standIndex, int measProcIndex, Device device);
  Future<void> writeMeasProcCalibrCurve(CalibrCurve calibrCurve,  int measProcIndex, Device device);
  Future<void> makeStandartization(StandSettings stand, int standIndex, int measProcIndex, Device device); 
  Future<void> writeMeasProcSingleMeasDuration(int duration, int measProcIndex, Device device);


  Future<void> switchMeasState(bool value, Device device);

  void dispose();
}
