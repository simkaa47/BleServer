import 'dart:async';

import 'package:idensity_ble_client/models/connection_settings.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:rxdart/rxdart.dart';

class Device {
  static const settingsPollInterval = Duration(seconds: 5);
  static const indicationPollInterval = Duration(milliseconds: 500);

  int? id;
  bool connected = false;
  ConnectionSettings connectionSettings = ConnectionSettings();
  IndicationData? _indicationData;
  DeviceSettings? _deviceSettings;
  IndicationData? get indicationData => _indicationData;
  DeviceSettings? get deviceSettings => _deviceSettings;
  String name = "";

  DateTime _lastSettingsReadTime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime _lastIndicationReadTime = DateTime.fromMillisecondsSinceEpoch(0);

  /// Returns true when enough time has passed since the last settings read.
  bool get shouldReadSettings =>
      DateTime.now().difference(_lastSettingsReadTime) >= settingsPollInterval;

  /// Call after successfully reading settings from the device.
  void markSettingsRead() => _lastSettingsReadTime = DateTime.now();

  /// Call after writing any setting — forces a re-read on the next poll cycle.
  void invalidateSettings() =>
      _lastSettingsReadTime = DateTime.fromMillisecondsSinceEpoch(0);

  bool get shouldReadIndication =>
      DateTime.now().difference(_lastIndicationReadTime) >= indicationPollInterval;

  void markIndicationRead() => _lastIndicationReadTime = DateTime.now();


  

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
