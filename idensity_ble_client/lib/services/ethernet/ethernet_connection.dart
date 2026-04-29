import 'package:idensity_ble_client/models/adc/adc_frame.dart';
import 'package:idensity_ble_client/models/connection.dart';
import 'package:idensity_ble_client/models/connection_type.dart';
import 'package:idensity_ble_client/models/ethernet/ethernet_settings.dart';

class EthernetConnection implements Connection {
  EthernetConnection(this._settings);

  final EthernetSettings _settings;

  @override
  ConnectionType get connectionType => ConnectionType.ethernet;

  @override
  Stream<AdcFrame> get spectrumStream => Stream.empty(); // TODO: UDP server

  @override
  Future<List<int>> readBytes(List<int> request, {int? expectedRespLen}) {
    // TODO: implement TCP/IP Modbus transport
    throw UnimplementedError(
      'Ethernet connection not yet implemented (${_settings.ip})',
    );
  }

  @override
  Future<void> dispose() async {}
}
