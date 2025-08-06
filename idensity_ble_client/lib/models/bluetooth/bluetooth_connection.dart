import 'dart:ffi';
import 'package:flutter_blue_plus_windows/flutter_blue_plus_windows.dart';

class BluetoothConnection {
  BluetoothConnection({required this.remoteId});
  static const String serviceUuid = "d973f2e0-b19e-11e2-9e96-0800200c9a66";
  static const String characteristicWriteUuid =
      "d973f2e2-b19e-11e2-9e96-0800200c9a66";
  static const String characteristicReadUuid =
      "d973f2e1-b19e-11e2-9e96-0800200c9a66";
  String remoteId;
  BluetoothCharacteristic? _characteristicRead;
  BluetoothCharacteristic? _characteristicWrite;
  BluetoothDevice? bleDevice;

  Future<List<Uint8>> readBytes(List<Uint8> request) async {
    if (bleDevice == null || !bleDevice!.isConnected) {
      await _connect();
    }
    throw Exception("Need to implement");
  }

  Future<void> _connect() async {
    if (bleDevice == null || bleDevice!.remoteId.toString() != remoteId) {
      await bleDevice?.disconnect();
      bleDevice = BluetoothDevice.fromId(remoteId);
    }
    if (bleDevice != null) {
      await bleDevice!.connect();
      List<BluetoothService> services = await bleDevice!.discoverServices();
      final service =
          services
              .where((service) => service.uuid.toString() == serviceUuid)
              .firstOrNull;

      if (service == null) return;

      _characteristicWrite =
          service.characteristics
              .where(
                (characteristic) =>
                    characteristic.uuid.toString() == characteristicWriteUuid,
              )
              .firstOrNull;
      _characteristicRead =
          service.characteristics
              .where(
                (characteristic) =>
                    characteristic.uuid.toString() == characteristicReadUuid,
              )
              .firstOrNull;
    }
  }

  Future<void> dispose() async {
    await bleDevice?.disconnect();
  }
}
