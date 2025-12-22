import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idensity_ble_client/data_access/chart_settings_repository.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/services/device_service.dart';
import 'package:rxdart/rxdart.dart';

class ChartsSettingsService {
  final ChartSettingsRepository _chartSettingsRepository =
      ChartSettingsRepository();
  final DeviceService deviceService;
  List<ChartSettings> _settings = [];

  List<ChartSettings> get settings => _settings;

  final StreamController<List<ChartSettings>> _stateController =
      BehaviorSubject<List<ChartSettings>>();

  ChartsSettingsService({required this.deviceService});
  Stream<List<ChartSettings>> get settingsStream => _stateController.stream;

  Future<void> init() async {
    try {
      _settings = await _chartSettingsRepository.getSettings();
    } catch (e) {
      debugPrint(
        "Ошибка при инициализации таблицы настроек графиков из БД - $e",
      );
    } finally {
      _stateController.add(_settings);
    }
  }

  Future<void> addSettings(ChartSettings setts) async {
    try {
      await _chartSettingsRepository.add(setts);
      _settings = await _chartSettingsRepository.getSettings();
    } catch (e) {
      throw("Ошибка при добавлении настроек графиков в БД - $e");
    } finally {
      _stateController.add(_settings);
    }
  }


  Future<void> editSettings(ChartSettings setts) async {
    try {
      await _chartSettingsRepository.add(setts);     
    } catch (e) {
      throw("Ошибка при редактировании настроек графиков в БД - $e");
    } finally {
      _stateController.add(_settings);
    }
  }

  Future<void> deleteSettings(ChartSettings setts)async{
    
    try {
      if(await _chartSettingsRepository.delete(setts)){
        _settings.remove(setts);        
      }

    } catch (e) {
      throw("Ошибка при удалении настроек графиков в БД - $e");
    } finally {
      _stateController.add(_settings);
    }
  }






}
