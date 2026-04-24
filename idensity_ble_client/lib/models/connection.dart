import 'package:idensity_ble_client/models/adc/adc_frame.dart';
import 'package:idensity_ble_client/models/connection_type.dart';

abstract interface class Connection {
  ConnectionType get connectionType;
  Future<List<int>> readBytes(List<int> request, {int? expectedRespLen});
  Stream<AdcFrame> get spectrumStream;
  Future<void> dispose();
}
