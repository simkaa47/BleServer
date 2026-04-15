import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/settings/analog_output_settings.dart';
import 'package:idensity_ble_client/models/settings/counter_settings.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:idensity_ble_client/models/settings/get_temperature.dart';
import 'package:idensity_ble_client/models/settings/serial_settings.dart';
import 'package:idensity_ble_client/models/settings/tcp_settings.dart';

abstract interface class ModbusService {
  Future<IndicationData> getIndicationData(Connection connection);
  Future<DeviceSettings> getDeviceSettings(Connection connection);

  // Device type
  Future<void> writeDeviceType(int value, Connection connection);

  // Meas process settings
  Future<void> writeMeasDuration(double value, int measProcIndex, Connection connection);
  Future<void> writeAveragePoints(int value, int measProcIndex, Connection connection);
  Future<void> writeCalcType(int value, int measProcIndex, Connection connection);
  Future<void> writeMeasType(int value, int measProcIndex, Connection connection);
  Future<void> writeMeasActivity(bool value, int measProcIndex, Connection connection);
  Future<void> writeMeasDiameter(double value, int measProcIndex, Connection connection);
  Future<void> writeDensityLiquid(double value, int measProcIndex, Connection connection);
  Future<void> writeDensitySolid(double value, int measProcIndex, Connection connection);

  // Communication settings
  Future<void> writeModbusId(int value, Connection connection);
  Future<void> writeTcpSettings(TcpSettings settings, Connection connection);
  Future<void> writeSerialSettings(SerialSettings settings, Connection connection);

  // Counter settings
  Future<void> writeCounterSettings(CounterSettings settings, int counterIndex, Connection connection);

  // Analog output settings
  Future<void> writeAnalogOutputSettings(AnalogOutputSettings settings, int outputIndex, Connection connection);

  // Temperature compensation
  Future<void> writeTemperatureCompensation(GetTemperature settings, Connection connection);
}
