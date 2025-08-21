import 'dart:async';

import 'package:idensity_ble_client/data_access/meas_unit_repository.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit_seed.dart';
import 'package:rxdart/rxdart.dart';

class MeasUnitService {
  List<MeasUnit> _measUnits = [];
  List<MeasUnit> get measUnits => _measUnits;
  final MeasUnitRepository _measUnitRepository = MeasUnitRepository();
  final StreamController<List<MeasUnit>> _stateController =
      BehaviorSubject<List<MeasUnit>>();
  Stream<List<MeasUnit>> get measUnitsStream => _stateController.stream;

  Future<void> init() async {
    _measUnits = await _measUnitRepository.getMeasUnits();
    if (_measUnits.isEmpty) {
      _measUnits = MeasUnitSeed.getMeasUnits();
      await _measUnitRepository.loadMeasUnits(_measUnits);
    }
    _stateController.add(_measUnits);
  }

  Future<void> addMeasUnit(MeasUnit measUnit) async {
    await _measUnitRepository.addMeasUnit(measUnit);
    _measUnits = await _measUnitRepository.getMeasUnits();    
    _stateController.add(_measUnits);
  }

  Future<void> editMeasUnit(MeasUnit measUnit) async {
    await _measUnitRepository.addMeasUnit(measUnit);
    _stateController.add(_measUnits);
  }

  Future<bool> deleteMeasUnit(MeasUnit measUnit)async{
    var result = await _measUnitRepository.deleteMeasUnit(measUnit);
    if(result){
      _measUnits.remove(measUnit);
       _stateController.add(_measUnits);
    }
    return result;
  }

  void dispose() {
    _stateController.close();
  }
}
