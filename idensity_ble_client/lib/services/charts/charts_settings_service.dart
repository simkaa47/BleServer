import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idensity_ble_client/data_access/chart_settings_repository.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/models/charts/chart_type.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:rxdart/rxdart.dart';

class ChartsSettingsService {
  final ChartSettingsRepository chartSettingsRepository = ChartSettingsRepository();
  final DeviceService deviceService;
  List<ChartSettings> _settings = [];

  final StreamController<List<ChartSettings>> _stateController =
      BehaviorSubject<List<ChartSettings>>();

  ChartsSettingsService({required this.deviceService});
  Stream<List<ChartSettings>> get settingsStream => _stateController.stream;

  Future<void> init() async {    
    
    if(_settings.isEmpty){
      final devName = "Idensity_BLE";
      _settings = [
        ChartSettings(color: Colors.red, deviceName: devName, chartType: ChartType.averageValue0),
        ChartSettings(color: Colors.blue, deviceName: devName, chartType: ChartType.currentValue0),
        ChartSettings(color: Colors.black, deviceName: devName, chartType: ChartType.counter, rightAxis: true),
      ];
      _stateController.add(_settings);
    }
  }
}
