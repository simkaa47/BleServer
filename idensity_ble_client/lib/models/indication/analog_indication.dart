class AnalogIndication {
  final bool commState;
  final bool pwrState;
  final int adcValue;

  AnalogIndication({
    required this.commState,
    required this.pwrState,
    required this.adcValue,
  });
}
