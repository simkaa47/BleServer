import 'dart:async';

import 'package:idensity_ble_client/data_access/meas_unit_repository.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit_seed.dart';

class MeasUnitService {  

  List<MeasUnit> _measUnits = [];
  List<MeasUnit> get measUnits => _measUnits;
  final MeasUnitRepository _measUnitRepository = MeasUnitRepository();
  final StreamController<List<MeasUnit>> _stateController =
      StreamController<List<MeasUnit>>.broadcast();
  Stream<List<MeasUnit>> get measUnitsStream => _stateController.stream;

  Future<void> init() async {
    _measUnits = await _measUnitRepository.getMeasUnits();
    if(_measUnits.isEmpty){
      _measUnitRepository.loadMeasUnits(MeasUnitSeed.getMeasUnits());
    }
    _stateController.add(_measUnits);
  }


  void dispose(){
    _stateController.close();
  }
}
