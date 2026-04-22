import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/settings/calibr_curve.dart';
import 'package:idensity_ble_client/models/settings/analog_output_settings.dart';
import 'package:idensity_ble_client/models/settings/counter_settings.dart';
import 'package:idensity_ble_client/models/settings/fast_change.dart';
import 'package:idensity_ble_client/models/settings/serial_settings.dart';
import 'package:idensity_ble_client/models/settings/single_meas_result.dart';
import 'package:idensity_ble_client/models/settings/stand_settings.dart';
import 'package:idensity_ble_client/models/settings/tcp_settings.dart';

abstract interface class DeviceService {
  Stream<Device> get updateStream;
  Stream<List<Device>> get devicesStream;
  List<Device> get devices;

  Future<void> init();
  Future<void> addDevices(List<Device> newDevices);
  Future<void> removeDevice(Device device);

  Future<void> writeDeviceType(int type, Device device);
  Future<void> writeLevelLength(double value, Device device);
  Future<void> writeRtc(DateTime dt, Device device);
  Future<void> writeMeasDuration(double value, int measProcIndex, Device device);
  Future<void> writeAveragePoints(int value, int measProcIndex, Device device);
  Future<void> writeCalcType(int value, int measProcIndex, Device device);
  Future<void> writeMeasType(int value, int measProcIndex, Device device);
  Future<void> writeMeasDiameter(double value, int measProcIndex, Device device);
  Future<void> writeDensityLiquid(double value, int measProcIndex, Device device);
  Future<void> writeDensitySolid(double value, int measProcIndex, Device device);
  Future<void> writeFastChanges(FastChange fastChange, int measProcIndex, Device device);
  Future<void> writeMeasProcActivity(bool activity, int measProcIndex, Device device);
  Future<void> writeMeasProcStandartization(StandSettings stand, int standIndex, int measProcIndex, Device device);
  Future<void> writeMeasProcCalibrCurve(CalibrCurve calibrCurve,  int measProcIndex, Device device);
  Future<void> makeStandartization(StandSettings stand, int standIndex, int measProcIndex, Device device);
  Future<void> makeSingleMeasurement(int measIndex, int measProcIndex, Device device); 
  Future<void> writeMeasProcSingleMeasDuration(int duration, int measProcIndex, Device device);
  Future<void> writeSingleMeasResult(SingleMeasResult result, int measIndex, int measProcIndex, Device device);


  Future<void> writeCounterSettings(CounterSettings settings, int counterIndex, Device device);
  Future<void> writeModbusId(int value, Device device);
  Future<void> writeTcpSettings(TcpSettings settings, Device device);
  Future<void> writeSerialSettings(SerialSettings settings, Device device);
  Future<void> writeAnalogInputActivity(bool active, int inputIndex, Device device);
  Future<void> writeAnalogOutputSettings(AnalogOutputSettings settings, int outputIndex, Device device);
  Future<void> sendAnalogTestValue(int outputIndex, Device device);

  Future<void> switchMeasState(bool value, Device device);

  void dispose();
}
