import 'package:idensity_ble_client/models/settings/get_temperature_coeffs.dart';
import 'package:idensity_ble_client/models/settings/get_temperature_src.dart';

class GetTemperature {
  GetTemperatureSrc src = GetTemperatureSrc.none;
  final List<GetTemperatureCoeffs> coeffs = List.generate(2, (_) => GetTemperatureCoeffs());
}
