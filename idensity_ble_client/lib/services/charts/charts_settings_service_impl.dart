import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idensity_ble_client/data_access/chart_setting/chart_settings_repository.dart';
import 'package:idensity_ble_client/models/charts/chart_settings.dart';
import 'package:idensity_ble_client/services/charts/charts_settings_service.dart';
import 'package:rxdart/rxdart.dart';

class ChartsSettingsServiceImpl implements ChartsSettingsService {
  final ChartSettingsRepository _chartSettingsRepository;

  List<ChartSettings> _settings = [];

  @override
  List<ChartSettings> get settings => _settings;

  final StreamController<List<ChartSettings>> _stateController =
      BehaviorSubject<List<ChartSettings>>();

  ChartsSettingsServiceImpl({
    required ChartSettingsRepository chartSettingsRepository,
  }) : _chartSettingsRepository = chartSettingsRepository;

  @override
  Stream<List<ChartSettings>> get settingsStream => _stateController.stream;

  @override
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

  @override
  Future<void> addSettings(ChartSettings setts) async {
    try {
      await _chartSettingsRepository.add(setts);
      _settings = await _chartSettingsRepository.getSettings();
    } catch (e) {
      throw ("Ошибка при добавлении настроек графиков в БД - $e");
    } finally {
      _stateController.add(_settings);
    }
  }

  @override
  Future<void> editSettings(ChartSettings setts) async {
    try {
      await _chartSettingsRepository.add(setts);
    } catch (e) {
      throw ("Ошибка при редактировании настроек графиков в БД - $e");
    } finally {
      _stateController.add(_settings);
    }
  }

  @override
  Future<void> deleteSettings(ChartSettings setts) async {
    try {
      if (await _chartSettingsRepository.delete(setts)) {
        _settings.remove(setts);
      }
    } catch (e) {
      throw ("Ошибка при удалении настроек графиков в БД - $e");
    } finally {
      _stateController.add(_settings);
    }
  }
}
