import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';
import 'package:rxdart/subjects.dart';

class DeviceService {
  final Queue<Function> _commandQueue = Queue<Function>();

  final modbusService = ModbusService();

  final List<Connection> _connections = [];

  final _updateController = StreamController<Device>.broadcast();
  Stream<Device> get updateStream => _updateController.stream;

  final BehaviorSubject<List<Device>> _devicesController =
      BehaviorSubject<List<Device>>();

  Stream<List<Device>> get devicesStream => _devicesController.stream;
  final List<Device> _currentDevices = [];
  List<Device> get devices => List.unmodifiable(_currentDevices);

  Future<void> addDevices(List<Device> newDevices) async {
    for (var newDevice in newDevices) {
      if (!_currentDevices.any((d) => isEqual(d, newDevice))) {
       
        _currentDevices.add(newDevice);
         if(_currentDevices.length == 1){
          askDevices();
        }        
        _devicesController.add(List.from(_currentDevices));
        _connections.add(Connection(newDevice.connectionSettings));
        debugPrint(
          'Устройство добавлено: ${newDevice.name}. Текущих устройств: ${_currentDevices.length}',
        );
      }
    }
  }

  Future<void> removeDevice(Device device) async {
    await device.dispose();
    var connection =
        _connections.where((c) => c.name == device.name).firstOrNull;
    if (connection != null) {
      _connections.remove(connection);
      await connection.dispose();
    }
    _currentDevices.remove(device);
    _devicesController.add(
      List.from(_currentDevices),
    ); // Отправляем копию списка в поток
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
              _connections.where((c) => c.name == c.name).firstOrNull;
          if (connection != null) {
            // Получаем новые данные для устройства
            final newIndicationData = await _getIndicationData(connection);
            final newSettings = await _getDeviceSettings(connection);
            if (_commandQueue.isEmpty) {
              device.updateIndicationData(newIndicationData);
              device.updateDeviceSettings(newSettings);
            }
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
      }
    }
  }

  Future<IndicationData> _getIndicationData(Connection connection) async {
    return await modbusService.getIndicationData(connection);
  }

  Future<DeviceSettings> _getDeviceSettings(Connection connection) async {
    return await modbusService.getDeviceSettings(connection);
  }
  

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

  Future<void> writeDeviceType(int type, Device device) async {
    _commandQueue.add(() async {
      var connection = _connections.where((c) => c.name == c.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeDeviceType(type, connection);
      }
    });
  }

  Future<void> writeMeasDuration(double value, int measProcIndex, Device device)async{
    _commandQueue.add(() async {
      var connection = _connections.where((c) => c.name == c.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeMeasDuration(value, measProcIndex, connection);
      }
    });
  }

  Future<void> writeAveragePoints(int value, int measProcIndex, Device device) async {
    _commandQueue.add(() async {
      var connection = _connections.where((c) => c.name == c.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeAveragePoints(value, measProcIndex, connection);
      }
    });
  }

  Future<void> writeCalcType(int value, int measProcIndex, Device device)async{
    _commandQueue.add(() async {
      var connection = _connections.where((c) => c.name == c.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeCalcType(value, measProcIndex, connection);
      }
    });
  }

  Future<void> writeMeasType(int value, int measProcIndex, Device device)async{
    _commandQueue.add(() async {
      var connection = _connections.where((c) => c.name == c.name).firstOrNull;
      if (connection != null) {
        await modbusService.writeMeasType(value, measProcIndex, connection);
      }
    });
  }  
}
