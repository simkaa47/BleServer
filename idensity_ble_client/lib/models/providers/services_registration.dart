import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/chart_setting/chart_settings_repository_provider.dart';
import 'package:idensity_ble_client/data_access/data_log_cells/data_log_cells_repository_provider.dart';
import 'package:idensity_ble_client/data_access/device/device_repository_provider.dart';
import 'package:idensity_ble_client/data_access/meas_units/meas_units_repository_provider.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/settings/meas_process.dart';
import 'package:idensity_ble_client/services/bluetooth/ble_scan_service.dart';
import 'package:idensity_ble_client/services/charts/charts_settings_service.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/services/ethernet/ethernet_scan_service.dart';
import 'package:idensity_ble_client/services/meas_units/meas_unit_service.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';
import 'package:idensity_ble_client/services/scan_service.dart';

final scanServiceProvider = FutureProvider.family
    .autoDispose<ScanService, ConnectionType>((ref, conType) async {
      final deviceService = await ref.watch(deviceServiceProvider.future);
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

final deviceServiceProvider = FutureProvider<DeviceService>((ref) async{
  final logsRepo = ref.read(dataLogCellsRepositoryProvider);
  final deviceRepo = ref.read(deviceRepositoryProvider);
  final service = DeviceService(
    logCellRepository: logsRepo,
    deviceRepository: deviceRepo,
  );
  ref.onDispose(() => service.dispose());
  await service.init();
  return service;
});

final modbusServiceProvider = Provider<ModbusService>((ref) {
  return ModbusService();
});

final deviceUpdateProvider = StreamProvider<Device>((ref) {
  // Получаем экземпляр сервиса.
  final serviceAsyncValue = ref.watch(deviceServiceProvider);
  if (serviceAsyncValue.hasValue) {
    final service = serviceAsyncValue.value!;
    return service.updateStream;
  }
  if (serviceAsyncValue.isLoading) {
    return const Stream.empty();
  } else {
    throw Exception('Error loading  device service');
  }
});

final measUnitServiceProvider = FutureProvider<MeasUnitService>((ref) async {
  final repo = ref.read(measUnitsRepositoryProvider);
  final service = MeasUnitService(measUnitRepository: repo);

  // Регистрация метода dispose() для автоматического вызова
  // когда провайдер будет уничтожен
  ref.onDispose(() {
    service.dispose();
  });

  await service.init();
  return service;
});

final chartSettingsServiceProvider = FutureProvider<ChartsSettingsService>((
  ref,
) async {
  final deviceService = await ref.watch(deviceServiceProvider.future);

  final repo = ref.read(chartSettingsRepositoryProvider);

  final service = ChartsSettingsService(
    deviceService: deviceService,
    chartSettingsRepository: repo,
  );
  await service.init();
  return service;
});

final chartSettingsStreamProvider = StreamProvider<List<ChartSettings>>((ref) {
  final serviceAsyncValue = ref.watch(chartSettingsServiceProvider);
  if (serviceAsyncValue.hasValue) {
    final service = serviceAsyncValue.value!;
    return service.settingsStream;
  }

  if (serviceAsyncValue.isLoading) {
    return const Stream.empty();
  } else {
    throw Exception('Error loading service');
  }
});

final measUnitsStreamProvider = StreamProvider<List<MeasUnit>>((ref) {
  final serviceAsyncValue = ref.watch(measUnitServiceProvider);

  if (serviceAsyncValue.hasValue) {
    final service = serviceAsyncValue.value!;
    return service.measUnitsStream;
  }
  if (serviceAsyncValue.isLoading) {
    return const Stream.empty();
  } else {
    throw Exception('Error loading service');
  }
});

final devicesStreamProvider = StreamProvider<List<Device>>((ref) async* {
  final deviceService = await ref.watch(deviceServiceProvider.future);
  yield* deviceService.devicesStream;
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
});

final changeMeasUnitSelectingProvider = StreamProvider<Map<String, int>>((ref) {
  final serviceAsyncValue = ref.watch(measUnitServiceProvider);

  // Проверяем, что значение готово
  if (serviceAsyncValue.hasValue) {
    final service = serviceAsyncValue.value!;
    return service.measUnitSelectingStream;
  }

  // Если еще не готово, то остаемся в состоянии загрузки
  // (или ошибки)
  if (serviceAsyncValue.isLoading) {
    return const Stream.empty();
  } else {
    throw Exception('Error loading service');
  }
});
