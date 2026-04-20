import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'package:idensity_ble_client/models/device.dart';
import 'package:idensity_ble_client/models/indication/analog_input_indication.dart';
import 'package:idensity_ble_client/models/indication/analog_output_indication.dart';
import 'package:idensity_ble_client/models/indication/hv_board_telemetry.dart';
import 'package:idensity_ble_client/models/indication/meas_process_indication.dart';
import 'package:idensity_ble_client/models/indication/meas_result.dart';
import 'package:idensity_ble_client/models/indication/temp_board_telemetry.dart';

class IndicationData {
  bool isMeasuringState = false;
  bool adcBoardConnectState = false;
  DateTime rtc = DateTime.now();

  final TempBoardTelemetry tempBoardTelemetry = TempBoardTelemetry();
  final HvBoardTelemetry hvBoardTelemetry = HvBoardTelemetry();

  final measProcessIndications = List.generate(Device.measProcCnt, (i)=> MeasProcessIndication());

  // Backward-compatible getters used by existing widgets and services
  double get temperature => tempBoardTelemetry.temperature;
  double get hv => hvBoardTelemetry.outputVoltage;
  double get counters => measResults[0].counterValue;

  final List<MeasResult> measResults = List.generate(
    min(2, Device.measProcCnt),
    (i) => MeasResult(
      measProcIndex: 0,
      isActive: false,
      counterValue: 0,
      currentValue: 0,
      averageValue: 0,
    ),
  );

  final List<AnalogInputIndication> analogInputIndications = List.generate(
    min(2, Device.measProcCnt),
    (i) => AnalogInputIndication(adcValue: 0, commState: false, pwrState: false),
  );

  final List<AnalogOutputIndication> analogOutputIndications = List.generate(
    min(2, Device.measProcCnt),
    (i) => AnalogOutputIndication(
      adcValue: 0,
      commState: false,
      dacValue: 0,
      pwrState: false,
    ),
  );
}
