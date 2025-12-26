import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/services/meas_units/meas_unit_service.dart';

class ChartHelpers {
  static MeasUnit? getMeasUnit(
    ChartType chartType,
    MeasUnitService muService,
    String deviceName,
    List<Device> devices,
  ) {
    final device = devices.where((d) => d.name == deviceName).firstOrNull;

    if (device == null) {
      return null;
    }

    switch (chartType) {
      case ChartType.currentValue0:
      case ChartType.averageValue0:
        return muService.getMeasUnitForMeasProc(
          device.indicationData?.measResults[0].measProcIndex ?? 0,
          device.deviceSettings?.deviceMode.index ?? 0,
        );
      case ChartType.currentValue1:
      case ChartType.averageValue1:
        return muService.getMeasUnitForMeasProc(
          device.indicationData?.measResults[1].measProcIndex ?? 0,
          device.deviceSettings?.deviceMode.index ?? 0,
        );
      default:
        return null;
    }
  }

  static double getValueFromDevice(Device device, ChartType chartType) {
    switch (chartType) {
      case ChartType.counter:
        return device.indicationData?.counters ?? 0;
      case ChartType.currentValue0:
        return device.indicationData?.measResults[0].currentValue ?? 0;
      case ChartType.currentValue1:
        return device.indicationData?.measResults[1].currentValue ?? 0;
      case ChartType.averageValue0:
        return device.indicationData?.measResults[0].averageValue ?? 0;
      case ChartType.averageValue1:
        return device.indicationData?.measResults[1].averageValue ?? 0;
      case ChartType.hv:
        return device.indicationData?.hv ?? 0;
      case ChartType.temp:
        return device.indicationData?.temperature ?? 0;
      case ChartType.aiCurrent0:
        return device.indicationData?.analogInputIndications[0].current ?? 0;
      case ChartType.aiCurrent1:
        return device.indicationData?.analogInputIndications[1].current ?? 0;
      case ChartType.aoCurrent0:
        return device.indicationData?.analogOutputIndications[0].current ?? 0;
      case ChartType.aoCurrent1:
        return device.indicationData?.analogOutputIndications[1].current ?? 0;
    }
  }
}
