import 'dart:async';

import 'package:idensity_ble_client/models/connection_settings.dart';
import 'package:idensity_ble_client/models/indication/indication.dart';
import 'package:idensity_ble_client/models/settings/device_settings.dart';
import 'package:rxdart/rxdart.dart';

class Device {
  static const settingsPollInterval = Duration(seconds: 5);
  static const indicationPollInterval = Duration(milliseconds: 500);
  static const measProcCnt = 2;

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
      DateTime.now().difference(_lastIndicationReadTime) >=
      indicationPollInterval;

  void markIndicationRead() => _lastIndicationReadTime = DateTime.now();

  final _indicationDataController = BehaviorSubject<IndicationData>();
  Stream<IndicationData> get dataStream => _indicationDataController.stream;

  final _deviceSettingsController = BehaviorSubject<DeviceSettings>();
  Stream<DeviceSettings> get settingsStream => _deviceSettingsController.stream;

  dispose() {
    _indicationDataController.close();
    _deviceSettingsController.close();
  }

  void updateIndicationData(IndicationData data) {
    if (_indicationData != null) {
      final ftMeasure =
          _indicationData!.isMeasuringState && !data.isMeasuringState;

      for (var i = 0; i < Device.measProcCnt; i++) {
        final standsLen =
            _indicationData!.measProcessIndications[i].standIndications.length;
        final singlesLen =
            _indicationData!
                .measProcessIndications[i]
                .singleMeasureIndications
                .length;
        for (var j = 0; j < standsLen; j++) {
          data.measProcessIndications[i].standIndications[j] =
              _indicationData!.measProcessIndications[i].standIndications[j];
          data.measProcessIndications[i].standIndications[j].updateTime(
            _deviceSettings?.measProcesses[i].standSettings[j].standDuration,
          );
          if (ftMeasure) {
            data.measProcessIndications[i].standIndications[j].disactivate();
          }
        }
        for (var j = 0; j < singlesLen; j++) {
          data.measProcessIndications[i].singleMeasureIndications[j] =
              _indicationData!
                  .measProcessIndications[i]
                  .singleMeasureIndications[j];
          data.measProcessIndications[i].singleMeasureIndications[j].updateTime(
            _deviceSettings?.measProcesses[i].singleMeasTime,
          );
          if (ftMeasure) {
            data.measProcessIndications[i].singleMeasureIndications[j]
                .disactivate();
          }
        }
      }
    }

    _indicationData = data;
    _indicationDataController.add(data);
  }

  void updateDeviceSettings(DeviceSettings settings) {
    _deviceSettings = settings;
    _deviceSettingsController.add(settings);
  }
}
