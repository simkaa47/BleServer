import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/models/charts/chart_state.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/settings/meas_process.dart';
import 'package:idensity_ble_client/services/bluetooth/ble_scan_service.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/services/ethernet/ethernet_scan_service.dart';
import 'package:idensity_ble_client/services/meas_units/meas_unit_service.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';
import 'package:idensity_ble_client/services/scan_service.dart';
import 'package:idensity_ble_client/viewModels/main_chart_view_model.dart';

final scanServiceProvider = Provider.family
    .autoDispose<ScanService, ConnectionType>((ref, conType) {
      final deviceService = ref.read(deviceServiceProvider);
      ScanService? service;
      switch (conType) {
        case ConnectionType.bluetooth:
          service = BleScanService(deviceService: deviceService);
        default:
          service = EthernetScanService(deviceService: deviceService);
      }
      ref.onDispose(() {
        service?.dispose();
      });
      return service;
    });

final connectionTypeProvider = StateProvider<ConnectionType>(
  (ref) => ConnectionType.bluetooth,
);

final deviceServiceProvider = Provider<DeviceService>((ref) {
  final service = DeviceService();  
  ref.onDispose(() => service.dispose());
  return service;
});

final modbusServiceProvider = Provider<ModbusService>((ref) {
  return ModbusService();
});


final deviceUpdateProvider = StreamProvider<void>((ref) {
  // Получаем экземпляр сервиса.
  final service = ref.watch(deviceServiceProvider);
  // Возвращаем стрим, который будет слушать этот провайдер.
  return service.updateStream;
});

final chartViewModelProvider = NotifierProvider<MainChartViewModel, ChartState>(
  () => MainChartViewModel(),
);

final measUnitServiceProvider = FutureProvider<MeasUnitService>((ref) async {
  final service = MeasUnitService();

  // Регистрация метода dispose() для автоматического вызова
  // когда провайдер будет уничтожен
  ref.onDispose(() {
    service.dispose();
  });

  await service.init();
  return service;
});

final measUnitsStreamProvider = StreamProvider<List<MeasUnit>>((ref) {
  final serviceAsyncValue = ref.watch(measUnitServiceProvider);

  // Проверяем, что значение готово
  if (serviceAsyncValue.hasValue) {
    final service = serviceAsyncValue.value!;
    return service.measUnitsStream;
  }
  
  // Если еще не готово, то остаемся в состоянии загрузки
  // (или ошибки)
  if (serviceAsyncValue.isLoading) {
    return const Stream.empty();
  } else {
    throw Exception('Error loading service');
  }
});


final devicesStreamProvider = StreamProvider<List<Device>>((ref) {
  final deviceService = ref.watch(deviceServiceProvider);
  return deviceService.devicesStream;
});

final selectedDeviceIdProvider = StateProvider<String?>((ref) => null);

final selectedDeviceProvider = Provider<Device?>((ref) {  
  final devicesAsyncValue = ref.watch(devicesStreamProvider);  
  final selectedId = ref.watch(selectedDeviceIdProvider);

  
  return devicesAsyncValue.when(
    data: (devices) {
      if (selectedId != null) {
        return devices.firstWhere(
          (device) => device.name == selectedId,
          orElse: () => devices.first,
        );
      }
      return devices.isNotEmpty ? devices.first : null;
    },
    loading: () => null,
    error: (err, stack) => null,
  );
});

final selectedMeasProcIndexProvider = StateProvider<int>((ref) => 0);

final selectedMeasProcProvider = Provider<MeasProcess?>((ref) {
  final selectedMeasProcIndex = ref.watch(selectedMeasProcIndexProvider);
  final device = ref.watch(selectedDeviceProvider);

  return device?.deviceSettings?.measProcesses[selectedMeasProcIndex];

},);