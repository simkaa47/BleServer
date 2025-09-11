import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_blue_plus_platform_interface/flutter_blue_plus_platform_interface.dart';
import 'package:idensity_ble_client/flutter_blue_plus_wrapper/src/extensions/bluetooth_characteristic_extension.dart';

extension BluetoothServiceExtension on BluetoothService {
  BmBluetoothService toProto() {
    return BmBluetoothService(
      serviceUuid: serviceUuid,
      remoteId: DeviceIdentifier(remoteId.str),
      characteristics: [for (final c in characteristics) c.toProto()],
      primaryServiceUuid: null, // TODO:  API changes
    );
  }
}