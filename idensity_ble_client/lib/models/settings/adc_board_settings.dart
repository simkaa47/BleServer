import 'package:idensity_ble_client/models/settings/adc_board_mode.dart';

class AdcBoardSettings {
  AdcBoardMode mode = AdcBoardMode.oscilloscope;
  int syncLevel = 0;
  int timerSendData = 200;
  int gain = 0;
  List<int> updAddress = List.filled(4, 0);
  int udpPort = 0;
  int hvSv = 0;
  int peakSpectrumSv = 0;
  bool adcDataSendEnabled = false;
}
