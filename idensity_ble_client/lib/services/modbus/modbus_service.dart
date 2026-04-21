import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/settings/analog_output_settings.dart';
import 'package:idensity_ble_client/models/settings/calibr_curve.dart';
import 'package:idensity_ble_client/models/settings/counter_settings.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:idensity_ble_client/models/settings/fast_change.dart';
import 'package:idensity_ble_client/models/settings/get_temperature.dart';
import 'package:idensity_ble_client/models/settings/serial_settings.dart';
import 'package:idensity_ble_client/models/settings/single_meas_result.dart';
import 'package:idensity_ble_client/models/settings/stand_settings.dart';
import 'package:idensity_ble_client/models/settings/tcp_settings.dart';

abstract interface class ModbusService {
  Future<IndicationData> getIndicationData(Connection connection);
  Future<DeviceSettings> getDeviceSettings(Connection connection);

  // Device type
  Future<void> writeDeviceType(int value, Connection connection);

  Future<void> switchMeasState(bool value, Connection connection);

  // Meas process settings
  Future<void> writeMeasDuration(double value, int measProcIndex, Connection connection);
  Future<void> writeAveragePoints(int value, int measProcIndex, Connection connection);
  Future<void> writeCalcType(int value, int measProcIndex, Connection connection);
  Future<void> writeMeasType(int value, int measProcIndex, Connection connection);
  Future<void> writeMeasActivity(bool value, int measProcIndex, Connection connection);
  Future<void> writeMeasDiameter(double value, int measProcIndex, Connection connection);
  Future<void> writeDensityLiquid(double value, int measProcIndex, Connection connection);
  Future<void> writeDensitySolid(double value, int measProcIndex, Connection connection);
  Future<void> writeFastChanges(FastChange fastChange, int measProcIndex, Connection connection);
  Future<void> writeMeasProcActivity(bool activity, int measProcIndex, Connection connection);
  Future<void> writeMeasProcStandartization(StandSettings stand, int standIndex, int measProcIndex, Connection connection);
  Future<void> writeMeasProcCalibrCurve(CalibrCurve calibrCurve,  int measProcIndex, Connection connection);
  Future<void> makeStandartization(StandSettings stand, int standIndex, int measProcIndex, Connection connection);
  Future<void> makeSingleMeasurement(int measIndex, int measProcIndex, Connection connection);
  Future<void> writeMeasProcSingleMeasDuration(int duration, int measProcIndex, Connection connection);
  Future<void> writeSingleMeasResult(SingleMeasResult result, int measIndex, int measProcIndex, int isCheckedMask, Connection connection);

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
