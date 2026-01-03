import 'package:idensity_ble_client/data_access/app_database.dart';
import 'package:idensity_ble_client/data_access/device/device_extensions.dart';
import 'package:idensity_ble_client/data_access/device/device_repository.dart';
import 'package:idensity_ble_client/models/device.dart';

class DriftDeviceRepository implements DeviceRepository {
  final AppDatabase db;

  DriftDeviceRepository({required this.db});
  @override
  Future<void> add(Device device) async {
    await db.into(db.deviceRows).insertOnConflictUpdate(device.toCompanion());
  }

  @override
  Future<bool> delete(Device device) async {
    if (device.id == null) {
      return false;
    }

    final deleted =
        await (db.delete(db.deviceRows)
          ..where((t) => t.id.equals(device.id!))).go();

    return deleted > 0;
  }

  @override
  Future<List<Device>> getDevicesList() async {
    final rows = await db.select(db.deviceRows).get();
    return rows.map((e) => e.toModel()).toList();
  }
}
