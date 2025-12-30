
import 'package:drift/drift.dart';
import 'package:idensity_ble_client/data_access/app_database.dart';
import 'package:idensity_ble_client/models/meas_units/meas_unit.dart';
import 'package:idensity_ble_client/models/settings/device_mode.dart';

extension MeasUnitToCompanion on MeasUnit {
  MeasUnitRowsCompanion toCompanion() {
    return MeasUnitRowsCompanion(
      id: id == null ? const Value.absent() : Value(id!),
      name: Value(name),
      coeff: Value(coeff),
      offset: Value(offset),
      deviceMode: Value(deviceMode.index),
      measMode: Value(measMode),
      userCantDelete: Value(userCantDelete),
    );
  }
}

extension MeasUnitFromRow on MeasUnitRow {
  MeasUnit toModel() {
    return MeasUnit(
      id: id,
      name: name,
      coeff: coeff,
      offset: offset,
      deviceMode: DeviceMode.values[deviceMode],
      measMode: measMode,
      userCantDelete: userCantDelete,
    );
  }
}