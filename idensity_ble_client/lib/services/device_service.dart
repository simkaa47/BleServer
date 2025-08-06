import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication.dart';

class DeviceService {
  final StreamController<List<Device>> _devicesController = StreamController<List<Device>>.broadcast();
  Stream<List<Device>> get devicesStream => _devicesController.stream;
  final List<Device> _currentDevices = [];
  List<Device> get devices => List.unmodifiable(_currentDevices); 

  void addDevice(Device device) {
    _currentDevices.add(device);
    _devicesController.add(List.from(_currentDevices)); // Отправляем копию списка в поток
    debugPrint('Устройство добавлено: ${device.name}. Текущих устройств: ${_currentDevices.length}');
  }

  void removeDevice(Device device) {
    _currentDevices.remove(device);
    _devicesController.add(List.from(_currentDevices)); // Отправляем копию списка в поток
    debugPrint('Устройство удалено: ${device.name}. Текущих устройств: ${_currentDevices.length}');
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
    throw Exception('Need to be implemented');
  }


  void dispose(){
      _devicesController.close();
  }

}
