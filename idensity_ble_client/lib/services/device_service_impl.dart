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
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';
import 'package:rxdart/subjects.dart';

class DeviceServiceImpl implements DeviceService {
  DeviceServiceImpl({
    required this.logCellRepository,
    required this.deviceRepository,
    required this.modbusService,
  });

  final DataLogCellRepository logCellRepository;
  final DeviceRepository deviceRepository;
  final ModbusService modbusService;

  final Queue<Function> _commandQueue = Queue<Function>();
  final List<DataLogCellsCompanion> _logCells = [];
  final List<Connection> _connections = [];

  final _updateController = StreamController<Device>.broadcast();
  @override
  Stream<Device> get updateStream => _updateController.stream;

  final BehaviorSubject<List<Device>> _devicesController =
      BehaviorSubject<List<Device>>();

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
    for (var newDevice in newDevices) {
      if (!_currentDevices.any((d) => isEqual(d, newDevice))) {
        newDevice.id = await deviceRepository.add(newDevice);
        _currentDevices.add(newDevice);
        if (_currentDevices.length == 1) {
          askDevices();
        }

        _connections.add(
          Connection(newDevice.connectionSettings, name: newDevice.name),
        );
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
    await device.dispose();
    var connection =
        _connections.where((c) => c.name == device.name).firstOrNull;
    if (connection != null) {
      _connections.remove(connection);
      await connection.dispose();
    }
    _currentDevices.remove(device);
    _devicesController.add(List.from(_currentDevices));
    debugPrint(
      'Устройство удалено: ${device.name}. Текущих устройств: ${_currentDevices.length}',
    );
  }

  Future<void> askDevices() async {
    debugPrint('Начало опроса устройств...');
    while (_currentDevices.isNotEmpty) {
      try {
        final List<Device> devicesToUpdate = List.from(_currentDevices);
        for (var i = 0; i < devicesToUpdate.length; i++) {
          final device = devicesToUpdate[i];
          var connection =
              _connections.where((c) => c.name == device.name).firstOrNull;
          if (connection != null) {
            final newIndicationData = await _getIndicationData(connection);
            final newSettings = await _getDeviceSettings(connection);
            if (_commandQueue.isEmpty) {
              device.updateIndicationData(newIndicationData);
              device.updateDeviceSettings(newSettings);
            }
            await _log(device);
            _updateController.add(device);
            debugPrint('Обновлены данные для ${device.name}');
          }
        }
        if (devicesToUpdate.isEmpty) {
          await Future.delayed(const Duration(seconds: 1));
        } else {
          await Future.delayed(const Duration(milliseconds: 50));
        }
        if (_commandQueue.isNotEmpty) {
          final command = _commandQueue.removeFirst();
          try {
            await command();
          } catch (e) {
            debugPrint('Ошибка при выполнении команды: $e');
          }
        }
      } catch (e) {
        debugPrint('Ошибка при получении данных устройства: $e');
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Future<IndicationData> _getIndicationData(Connection connection) async {
    return await modbusService.getIndicationData(connection);
  }

  Future<DeviceSettings> _getDeviceSettings(Connection connection) async {
    return await modbusService.getDeviceSettings(connection);
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
        debugPrint("Проблема с записью в БД логов измерения");
      }
    }
  }

  @override
  void dispose() {
    _updateController.close();
    _devicesController.close();
    for (var device in devices) {
      device.dispose();
    }
    for (var connection in _connections) {
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

  @override
  Future<void> writeDeviceType(int type, Device device) async {
    _commandQueue.add(() async {
      var connection =
          _connections.where((c) => c.name == device.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeDeviceType(type, connection);
      }
    });
  }

  @override
  Future<void> writeMeasDuration(
    double value,
    int measProcIndex,
    Device device,
  ) async {
    _commandQueue.add(() async {
      var connection =
          _connections.where((c) => c.name == device.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeMeasDuration(value, measProcIndex, connection);
      }
    });
  }

  @override
  Future<void> writeAveragePoints(
    int value,
    int measProcIndex,
    Device device,
  ) async {
    _commandQueue.add(() async {
      var connection =
          _connections.where((c) => c.name == device.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeAveragePoints(
          value,
          measProcIndex,
          connection,
        );
      }
    });
  }

  @override
  Future<void> writeCalcType(
    int value,
    int measProcIndex,
    Device device,
  ) async {
    _commandQueue.add(() async {
      var connection =
          _connections.where((c) => c.name == device.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeCalcType(value, measProcIndex, connection);
      }
    });
  }

  @override
  Future<void> writeMeasType(
    int value,
    int measProcIndex,
    Device device,
  ) async {
    _commandQueue.add(() async {
      var connection =
          _connections.where((c) => c.name == device.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeMeasType(value, measProcIndex, connection);
      }
    });
  }
}
