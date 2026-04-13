import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';

abstract interface class ModbusService {
  Future<IndicationData> getIndicationData(Connection connection);
  Future<DeviceSettings> getDeviceSettings(Connection connection);

  Future<void> writeDeviceType(int value, Connection connection);
  Future<void> writeMeasDuration(double value, int measProcIndex, Connection connection);
  Future<void> writeAveragePoints(int value, int measProcIndex, Connection connection);
  Future<void> writeCalcType(int value, int measProcIndex, Connection connection);
  Future<void> writeMeasType(int value, int measProcIndex, Connection connection);
}
