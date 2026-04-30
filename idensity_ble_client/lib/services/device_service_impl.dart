import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:idensity_ble_client/data_access/data_log_cells/data_log_cell_repository.dart';
import 'package:idensity_ble_client/data_access/app_database.dart';
import 'package:idensity_ble_client/data_access/device/device_repository.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/settings/adc_board_settings.dart';
import 'package:idensity_ble_client/models/settings/calibr_curve.dart';
import 'package:idensity_ble_client/models/settings/analog_output_settings.dart';
import 'package:idensity_ble_client/models/settings/counter_settings.dart';
import 'package:idensity_ble_client/models/settings/fast_change.dart';
import 'package:idensity_ble_client/models/settings/serial_settings.dart';
import 'package:idensity_ble_client/models/settings/single_meas_result.dart';
import 'package:idensity_ble_client/models/settings/stand_settings.dart';
import 'package:idensity_ble_client/models/settings/tcp_settings.dart';
import 'package:idensity_ble_client/services/bluetooth/ble_connection.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/services/diagnostic/diagnostic_service.dart';
import 'package:idensity_ble_client/services/ethernet/ethernet_connection.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';
import 'package:rxdart/subjects.dart';

class DeviceServiceImpl implements DeviceService {
  DeviceServiceImpl({
    required this.logCellRepository,
    required this.deviceRepository,
    required this.modbusService,
    required this.diagnosticService,
  });

  final DataLogCellRepository logCellRepository;
  final DeviceRepository deviceRepository;
  final ModbusService modbusService;
  final DiagnosticService diagnosticService;

  final Queue<(Device, Future<void> Function())> _commandQueue = Queue();
  final List<DataLogCellsCompanion> _logCells = [];
  final Map<Device, Connection> _connections = {};
  final Map<Device, StreamSubscription<dynamic>> _spectrumSubscriptions = {};

  final _updateController = StreamController<Device>.broadcast();
  @override
  Stream<Device> get updateStream => _updateController.stream;

  final BehaviorSubject<List<Device>> _devicesController = BehaviorSubject();

  @override
  Stream<List<Device>> get devicesStream => _devicesController.stream;

  final List<Device> _currentDevices = [];
  @override
  List<Device> get devices => List.unmodifiable(_currentDevices);

  @override
  Future<void> init() async {
    final devices = await deviceRepository.getDevicesList();
    await addDevices(devices);
  }

  @override
  Future<void> addDevices(List<Device> newDevices) async {
    for (final newDevice in newDevices) {
      if (!_currentDevices.any((d) => isEqual(d, newDevice))) {
        newDevice.id = await deviceRepository.add(newDevice);
        _currentDevices.add(newDevice);
        diagnosticService.registerDevice(newDevice);
        final connection = _createConnection(newDevice);
        _connections[newDevice] = connection;
        _spectrumSubscriptions[newDevice] = connection.spectrumStream
            .listen((frame) => newDevice.updateAdcFrame(frame));
        if (_currentDevices.length == 1) {
          askDevices();
        }
        debugPrint(
          'Устройство добавлено: ${newDevice.name}. Текущих устройств: ${_currentDevices.length}',
        );
      }
    }
    _devicesController.add(List.from(_currentDevices));
  }

  @override
  Future<void> removeDevice(Device device) async {
    await deviceRepository.delete(device);
    _currentDevices.remove(device);
    diagnosticService.unregisterDevice(device);
    await _spectrumSubscriptions.remove(device)?.cancel();
    await _connections.remove(device)?.dispose();
    await device.dispose();
    _devicesController.add(List.from(_currentDevices));
    debugPrint(
      'Устройство удалено: ${device.name}. Текущих устройств: ${_currentDevices.length}',
    );
  }

  Future<void> askDevices() async {
    debugPrint('Начало опроса устройств...');
    while (_currentDevices.isNotEmpty) {
      final devicesToUpdate = List<Device>.from(_currentDevices);
      for (final device in devicesToUpdate) {
        final connection = _connections[device];
        if (connection == null) continue;
        try {
          if (device.shouldReadIndication) {
            final newIndicationData = await modbusService.getIndicationData(
              connection,
            );
            device.markIndicationRead();
            if (_commandQueue.isEmpty) {
              device.updateIndicationData(newIndicationData);
            }
            diagnosticService.check(device, newIndicationData);
            await _log(device);
            _updateController.add(device);
            debugPrint('Обновлены данные для ${device.name}');
          }
          if (device.shouldReadSettings) {
            final newSettings = await modbusService.getDeviceSettings(
              connection,
            );
            device.updateDeviceSettings(newSettings);
            device.markSettingsRead();
          }
          device.updateConnectionState(true);
          diagnosticService.updateConnectionEvent(device, true);
        } catch (e) {
          device.updateConnectionState(false);
          diagnosticService.updateConnectionEvent(device, false);
          debugPrint('Ошибка при получении данных устройства ${device.name}: $e');
        }
      }

      if (devicesToUpdate.isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      } else {
        await Future.delayed(const Duration(milliseconds: 50));
      }

      if (_commandQueue.isNotEmpty) {
        final (device, command) = _commandQueue.removeFirst();
        try {
          await command();
          device.invalidateSettings();
        } catch (e) {
          debugPrint('Ошибка при выполнении команды: $e');
        }
      }
    }
  }

  Future<void> _log(Device device) async {
    final dt = DateTime.now();
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.counter.index,
        dt: dt,
        value: device.indicationData?.counters ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.currentValue0.index,
        dt: dt,
        value: device.indicationData?.measResults[0].currentValue ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.averageValue0.index,
        dt: dt,
        value: device.indicationData?.measResults[0].averageValue ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.currentValue1.index,
        dt: dt,
        value: device.indicationData?.measResults[1].currentValue ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.averageValue1.index,
        dt: dt,
        value: device.indicationData?.measResults[1].averageValue ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.aiCurrent0.index,
        dt: dt,
        value: device.indicationData?.analogInputIndications[0].current ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.aoCurrent0.index,
        dt: dt,
        value: device.indicationData?.analogOutputIndications[0].current ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.aiCurrent1.index,
        dt: dt,
        value: device.indicationData?.analogInputIndications[1].current ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.aoCurrent1.index,
        dt: dt,
        value: device.indicationData?.analogOutputIndications[1].current ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.hv.index,
        dt: dt,
        value: device.indicationData?.hv ?? 0,
      ),
    );
    _logCells.add(
      DataLogCellsCompanion.insert(
        deviceName: device.name,
        chartType: ChartType.temp.index,
        dt: dt,
        value: device.indicationData?.temperature ?? 0,
      ),
    );
    if (_logCells.length > 100) {
      try {
        logCellRepository.insertBatch(_logCells);
        _logCells.clear();
      } catch (e) {
        debugPrint('Проблема с записью в БД логов измерения');
      }
    }
  }

  @override
  void dispose() {
    _updateController.close();
    _devicesController.close();
    for (final device in _currentDevices) {
      device.dispose();
    }
    for (final connection in _connections.values) {
      connection.dispose();
    }
  }

  bool isEqual(Device first, Device second) {
    return first.connectionSettings.connectionType ==
                second.connectionSettings.connectionType &&
            (first.connectionSettings.connectionType ==
                    ConnectionType.bluetooth &&
                first.connectionSettings.bluetoothSettings.macAddress ==
                    second.connectionSettings.bluetoothSettings.macAddress) ||
        (first.connectionSettings.connectionType == ConnectionType.ethernet &&
            first.connectionSettings.ethernetSettings.ip ==
                second.connectionSettings.ethernetSettings.ip);
  }

  void _enqueue(Device device, Future<void> Function() command) =>
      _commandQueue.add((device, command));

  @override
  Future<void> writeDeviceType(int type, Device device) async {
    _enqueue(device, () async {
      await _connection(
        device,
      )?.let((c) => modbusService.writeDeviceType(type, c));
    });
  }

  @override
  Future<void> writeAdcBoardSettings(AdcBoardSettings settings, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeAdcBoardSettings(settings, c),
      );
    });
  }

  @override
  Future<void> writeRtc(DateTime dt, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeRtc(dt, c),
      );
    });
  }

  @override
  Future<void> writeLevelLength(double value, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeLevelLength(value, c),
      );
    });
  }

  @override
  Future<void> writeMeasDuration(
    double value,
    int measProcIndex,
    Device device,
  ) async {
    _enqueue(device, () async {
      await _connection(
        device,
      )?.let((c) => modbusService.writeMeasDuration(value, measProcIndex, c));
    });
  }

  @override
  Future<void> writeAveragePoints(
    int value,
    int measProcIndex,
    Device device,
  ) async {
    _enqueue(device, () async {
      await _connection(
        device,
      )?.let((c) => modbusService.writeAveragePoints(value, measProcIndex, c));
    });
  }

  @override
  Future<void> writeCalcType(
    int value,
    int measProcIndex,
    Device device,
  ) async {
    _enqueue(device, () async {
      await _connection(
        device,
      )?.let((c) => modbusService.writeCalcType(value, measProcIndex, c));
    });
  }

  @override
  Future<void> writeMeasType(
    int value,
    int measProcIndex,
    Device device,
  ) async {
    _enqueue(device, () async {
      await _connection(
        device,
      )?.let((c) => modbusService.writeMeasType(value, measProcIndex, c));
    });
  }

  Connection? _connection(Device device) => _connections[device];

  Connection _createConnection(Device device) => switch (device
      .connectionSettings
      .connectionType) {
    ConnectionType.bluetooth => BleConnection(
      device.connectionSettings.bluetoothSettings,
    ),
    ConnectionType.ethernet => EthernetConnection(
      device.connectionSettings.ethernetSettings,
    ),
  };

  @override
  Future<void> writeMeasDiameter(double value, int measProcIndex, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeMeasDiameter(value, measProcIndex, c),
      );
    });
  }

  @override
  Future<void> writeDensityLiquid(double value, int measProcIndex, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeDensityLiquid(value, measProcIndex, c),
      );
    });
  }

  @override
  Future<void> writeDensitySolid(double value, int measProcIndex, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeDensitySolid(value, measProcIndex, c),
      );
    });
  }

  @override
  Future<void> writeFastChanges(
    FastChange fastChange,
    int measProcIndex,
    Device device,
  ) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeFastChanges(fastChange, measProcIndex, c),
      );
    });
  }

  @override
  Future<void> writeMeasProcActivity(
    bool activity,
    int measProcIndex,
    Device device,
  ) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeMeasProcActivity(activity, measProcIndex, c),
      );
    });
  }

  @override
  Future<void> writeMeasProcStandartization(
    StandSettings stand,
    int standIndex,
    int measProcIndex,
    Device device,
  ) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeMeasProcStandartization(
          stand,
          standIndex,
          measProcIndex,
          c,
        ),
      );
    });
  }

  bool _anyMeasureActive(Device device) =>
      device.indicationData?.measProcessIndications.any(
        (proc) =>
            proc.standIndications.any((s) => s.isActive) ||
            proc.singleMeasureIndications.any((s) => s.isActive),
      ) ??
      false;

  @override
  Future<void> makeStandartization(
    StandSettings stand,
    int standIndex,
    int measProcIndex,
    Device device,
  ) async {
    final indications = device.indicationData;
    if (indications != null && !indications.isMeasuringState && !_anyMeasureActive(device)) {
      _enqueue(device, () async {
        indications.measProcessIndications[measProcIndex].standIndications[standIndex].activate();
        await _connection(device)?.let(
          (c) => modbusService.makeStandartization(
            stand,
            standIndex,
            measProcIndex,
            c,
          ),
        );
      });
    }
  }
  
  @override
  Future<void> makeSingleMeasurement(
    int measIndex,
    int measProcIndex,
    Device device,
  ) async {
    final indications = device.indicationData;
    if (indications != null && !indications.isMeasuringState && !_anyMeasureActive(device)) {
      _enqueue(device, () async {
        indications.measProcessIndications[measProcIndex].singleMeasureIndications[measIndex].activate();
        await _connection(device)?.let(
          (c) => modbusService.makeSingleMeasurement(measIndex, measProcIndex, c),
        );
      });
    }
  }

  @override
  Future<void> writeCounterSettings(CounterSettings settings, int counterIndex, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeCounterSettings(settings, counterIndex, c),
      );
    });
  }

  @override
  Future<void> writeAnalogOutputSettings(AnalogOutputSettings settings, int outputIndex, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeAnalogOutputSettings(settings, outputIndex, c),
      );
    });
  }

  @override
  Future<void> sendAnalogTestValue(int outputIndex, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.sendAnalogTestValue(outputIndex, c),
      );
    });
  }

  @override
  Future<void> writeAnalogInputActivity(bool active, int inputIndex, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeAnalogInputActivity(active, inputIndex, c),
      );
    });
  }

  @override
  Future<void> writeModbusId(int value, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeModbusId(value, c),
      );
    });
  }

  @override
  Future<void> writeTcpSettings(TcpSettings settings, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeTcpSettings(settings, c),
      );
    });
  }

  @override
  Future<void> writeSerialSettings(SerialSettings settings, Device device) async {
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) => modbusService.writeSerialSettings(settings, c),
      );
    });
  }

  @override
  Future<void> switchMeasState(bool value, Device device) async{
     _enqueue(device, () async {
      await _connection(device)?.let(
        (c) =>  modbusService.switchMeasState(value, c)
      );
    });
  }

  @override
  Future<void> writeMeasProcCalibrCurve(CalibrCurve calibrCurve, int measProcIndex, Device device) async{
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) =>  modbusService.writeMeasProcCalibrCurve(calibrCurve, measProcIndex, c)
      );
    });
  }
  
  @override
  Future<void> writeMeasProcSingleMeasDuration(int duration, int measProcIndex, Device device) async{
    _enqueue(device, () async {
      await _connection(device)?.let(
        (c) =>  modbusService.writeMeasProcSingleMeasDuration(duration, measProcIndex, c)
      );
    });
  }

  @override
  Future<void> writeSingleMeasResult(
    SingleMeasResult result,
    int measIndex,
    int measProcIndex,
    Device device,
  ) async {
    _enqueue(device, () async {
      final results = device.deviceSettings?.measProcesses[measProcIndex].singleMeasResults;
      if (results == null) return;
      int mask = 0;
      for (var i = 0; i < results.length; i++) {
        final isChecked = i == measIndex ? result.isChecked : results[i].isChecked;
        if (isChecked) mask |= (1 << i);
      }
      await _connection(device)?.let(
        (c) => modbusService.writeSingleMeasResult(result, measIndex, measProcIndex, mask, c),
      );
    });
  }
}

extension _Nullsafe<T> on T {
  R let<R>(R Function(T) fn) => fn(this);
}
