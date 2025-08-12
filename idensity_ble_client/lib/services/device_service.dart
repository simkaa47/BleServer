import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication.dart';
import 'package:idensity_ble_client/services/modbus/modbus_service.dart';

class DeviceService {
  final modbusService = ModbusService();
  DeviceService() {
    askDevices();
  }

  final List<Connection> _connections = [];

  final StreamController<List<Device>> _devicesController =
      StreamController<List<Device>>.broadcast();
  Stream<List<Device>> get devicesStream => _devicesController.stream;
  final List<Device> _currentDevices = [];
  List<Device> get devices => List.unmodifiable(_currentDevices);

  Future<void> addDevices(List<Device> newDevices) async {
    for (var newDevice in newDevices) {
      if (!_currentDevices.any((d) => isEqual(d, newDevice))) {
        _currentDevices.add(newDevice);
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
    while (true) {
      try {
        // Создаем временную копию списка для итерации, чтобы избежать ConcurrentModificationError
        final List<Device> devicesToUpdate = List.from(_currentDevices);

        for (var i = 0; i < devicesToUpdate.length; i++) {
          final device = devicesToUpdate[i];
          var connection =
              _connections.where((c) => c.name == c.name).firstOrNull;
          if (connection != null) {
            // Получаем новые данные для устройства
            final newIndicationData = await getIndicationData(connection);
            // Обновляем данные устройства
            device.updateIndicationData(newIndicationData);
            debugPrint('Обновлены данные для ${device.name}');
          }
        }
        _devicesController.add(List.from(_currentDevices));
      } catch (e) {
        debugPrint('Ошибка при получении данных устройства: $e');
      }

      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<IndicationData> getIndicationData(Connection connection) async {
    return await modbusService.getIndicationData(connection);
  }

  void dispose() {
    _devicesController.close();
    for (var device in devices) {
      device.dispose();
    }
  }

  bool isEqual(Device first, Device second) {
    return first.connectionSettings.connectionType == second.connectionSettings.connectionType &&
            (first.connectionSettings.connectionType == ConnectionType.bluetooth &&
                first.connectionSettings.bluetoothSettings.macAddress ==
                    second.connectionSettings.bluetoothSettings.macAddress) ||
        (first.connectionSettings.connectionType == ConnectionType.ethernet &&
            first.connectionSettings.ethernetSettings.ip == second.connectionSettings.ethernetSettings.ip);
  }
}
