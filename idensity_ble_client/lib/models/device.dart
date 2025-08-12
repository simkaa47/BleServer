import 'dart:async';

import 'package:idensity_ble_client/models/connection_settings.dart';
import 'package:idensity_ble_client/models/indication.dart';

class Device {
  bool connected = false;
  ConnectionSettings connectionSettings = ConnectionSettings();
  IndicationData? _indicationData;
  IndicationData? get indicationData => _indicationData;
  String name = "";

  final _indicationDataController =
      StreamController<IndicationData>.broadcast();
  Stream<IndicationData> get dataStream => _indicationDataController.stream;

  dispose() {
    _indicationDataController.close();
  }

  void updateIndicationData(IndicationData data){
    _indicationData = data;
    _indicationDataController.add(data);
  }
}
