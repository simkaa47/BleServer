enum AdcFrameType { oscilloscope, spectrumPartial, spectrumFull, counters }

class AdcFrame {
  const AdcFrame({required this.type, required this.samples});
  final AdcFrameType type;
  final List<int> samples;
}
