import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:idensity_ble_client/data_access/app_database_provider.dart';
import 'package:idensity_ble_client/data_access/device/device_repository.dart';
import 'package:idensity_ble_client/data_access/device/drift_device_repository.dart';

final deviceRepositoryProvider = Provider<DeviceRepository>((ref){
  final db = ref.read(appDatabaseProvider);
  return DriftDeviceRepository(db: db);
});