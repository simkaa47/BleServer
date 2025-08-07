import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication.dart';

class DeviceService {

  DeviceService(){
    askDevices();
  }

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
        debugPrint(
          'Устройство добавлено: ${newDevice.name}. Текущих устройств: ${_currentDevices.length}',
        );
      }
    }
  }



  Future<void> removeDevice(Device device) async {
    await device.dispose();
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
          // Получаем новые данные для устройства
          final newIndicationData = await getIndicationData(device);
          // Обновляем данные устройства
          device.indicationData = newIndicationData;
          debugPrint('Обновлены данные для ${device.name}');
        }
        _devicesController.add(List.from(_currentDevices));
      } catch (e) {
        debugPrint('Ошибка при получении данных устройства: $e');
      }

      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<IndicationData> getIndicationData(Device device) async {
    var response = await device.readBytes([1, 2, 3]);
    return device.indicationData;
  }

  void dispose() {
    _devicesController.close();
  }

  bool isEqual(Device first, Device second) {
    return first.connectionType == second.connectionType &&
            (first.connectionType == ConnectionType.bluetooth &&
                first.bluetoothSettings.macAddress ==
                    second.bluetoothSettings.macAddress) ||
        (first.connectionType == ConnectionType.ethernet &&
            first.ethernetSettings.ip == second.ethernetSettings.ip);
  }
}
