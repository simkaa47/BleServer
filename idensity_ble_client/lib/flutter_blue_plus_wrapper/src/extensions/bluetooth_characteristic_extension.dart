import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:idensity_ble_client/flutter_blue_plus_wrapper/src/extensions/bluetooth_descriptor_extension.dart';
import 'package:idensity_ble_client/flutter_blue_plus_wrapper/src/extensions/characteristic_properties_extension.dart';
import 'package:flutter_blue_plus_platform_interface/flutter_blue_plus_platform_interface.dart';

extension BluetoothCharacteristicExtension on BluetoothCharacteristic {
  BmBluetoothCharacteristic toProto() {
    return BmBluetoothCharacteristic(
      remoteId: DeviceIdentifier(remoteId.str),
      serviceUuid: serviceUuid,
      characteristicUuid: characteristicUuid,
      descriptors: [for (final d in descriptors) d.toProto()],
      properties: properties.toProto(),
      primaryServiceUuid: null, // TODO:  API changes
    );
  }
}