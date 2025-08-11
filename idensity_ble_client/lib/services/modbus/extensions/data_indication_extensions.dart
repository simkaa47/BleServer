import 'dart:developer';

import 'package:idensity_ble_client/models/indication.dart';
import 'package:idensity_ble_client/services/modbus/extensions/common_extensions.dart';

extension DataIndicationArrayExtensions on IndicationData{
  void updateDataFromModbus(List<int> registers){
    counters = registers.getFloat(2);
    log("Counters = $counters");
  }
}