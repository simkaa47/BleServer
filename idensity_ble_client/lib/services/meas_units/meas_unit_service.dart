import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:idensity_ble_client/data_access/meas_unit_repository.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit_seed.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class MeasUnitService {
  List<MeasUnit> _measUnits = [];
  Map<String, int> _measUnitSelecting = {};
  List<MeasUnit> get measUnits => _measUnits;
  final MeasUnitRepository _measUnitRepository = MeasUnitRepository();
  final StreamController<List<MeasUnit>> _stateController =
      BehaviorSubject<List<MeasUnit>>();
  Stream<List<MeasUnit>> get measUnitsStream => _stateController.stream;

  // Журнал ЕИ
  Future<String> get _measUnitSelectingPath async {
    final Directory directory =  Platform.isLinux ? Directory("/home/Documents/") :  await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _measUnitSelectingPathFile async {
    final path = await _measUnitSelectingPath;
    return File('$path/meas_units.json');
  }

  final StreamController<Map<String, int>> _measUnitSelectingController =
      BehaviorSubject<Map<String, int>>();

  Stream<Map<String, int>> get measUnitSelectingStream =>
      _measUnitSelectingController.stream;

  Future<void> init() async {
    _measUnits = await _measUnitRepository.getMeasUnits();
    if (_measUnits.isEmpty) {
      _measUnits = MeasUnitSeed.getMeasUnits();
      await _measUnitRepository.loadMeasUnits(_measUnits);
    }
    await _initMeasUnitsSelectDictionary();
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

  Future<bool> deleteMeasUnit(MeasUnit measUnit) async {
    var result = await _measUnitRepository.deleteMeasUnit(measUnit);
    if (result) {
      _measUnits.remove(measUnit);
      _stateController.add(_measUnits);
    }
    return result;
  }

  Future<void> _initMeasUnitsSelectDictionary() async {
    try {
      final file = await _measUnitSelectingPathFile;
      if (!await file.exists()) {
        return;
      }
      final contents = await file.readAsString();
      final jsonMap = json.decode(contents) as Map<String, dynamic>;
      _measUnitSelecting = jsonMap.map((key, value) {
        if (value is int) {
          return MapEntry(key, value);
        } else if (value is num) {
          return MapEntry(key, value.toInt());
        } else {
          return MapEntry(key, 0);
        }
      });
    } catch (e) {
      debugPrint("$e");
    } finally {
      _measUnitSelectingController.add(_measUnitSelecting);
    }
  }

  Future<void> changeMeasUnit(MeasUnit unit) async {
    final key = "${unit.measMode}_${unit.deviceMode.index}";
    try {
      _measUnitSelecting[key] = unit.id ?? 0;
      final jsonString = json.encode(_measUnitSelecting);
      final file = await _measUnitSelectingPathFile;
      await file.writeAsString(jsonString);
    } catch (e) {
      debugPrint("$e");
    }
    _measUnitSelectingController.add(_measUnitSelecting);
  }

  void dispose() {
    _stateController.close();
    _measUnitSelectingController.close();
  }

  List<MeasUnit> getMeasUnitsForMeasProc(int measMode, int deviceMode) {
    return measUnits
        .where((mu) => mu.deviceMode.index == deviceMode)
        .where((mu) => mu.measMode == measMode)
        .toList();
  }

  MeasUnit? getMeasUnitForMeasProc(int measMode, int deviceMode) {
    final key = "${measMode}_$deviceMode";
    final index = _measUnitSelecting[key];
    MeasUnit? measUnit;

    if (index != null) {
      measUnit =
          measUnits
              .where((mu) => mu.deviceMode.index == deviceMode)
              .where((mu) => mu.measMode == measMode)
              .where((mu) => mu.id == index)
              .firstOrNull;
    }
    measUnit ??=
        measUnits
            .where((mu) => mu.deviceMode.index == deviceMode)
            .where((mu) => mu.measMode == measMode)
            .firstOrNull;

    return measUnit;
  }
}
