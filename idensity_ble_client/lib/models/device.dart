import 'dart:async';

import 'package:idensity_ble_client/models/connection_settings.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:rxdart/rxdart.dart';

class Device {
  bool connected = false;
  ConnectionSettings connectionSettings = ConnectionSettings();
  IndicationData? _indicationData;
  DeviceSettings? _deviceSettings;
  IndicationData? get indicationData => _indicationData;
  DeviceSettings? get deviceSettings => _deviceSettings;
  String name = "";

  final _indicationDataController =
      BehaviorSubject<IndicationData>();
  Stream<IndicationData> get dataStream => _indicationDataController.stream;

  final _deviceSettingsController =
      BehaviorSubject<DeviceSettings>();
  Stream<DeviceSettings> get settingsStream => _deviceSettingsController.stream;

  dispose() {
    _indicationDataController.close();
    _deviceSettingsController.close();
  }

  void updateIndicationData(IndicationData data) {
    _indicationData = data;
    _indicationDataController.add(data);
  }

  void updateDeviceSettings(DeviceSettings settings){
    _deviceSettings = settings;
    _deviceSettingsController.add(settings);
  }
}
