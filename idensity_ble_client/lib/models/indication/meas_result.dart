class MeasResult {
  final int measProcIndex;
  final bool isActive;
  final double counterValue;
  final double currentValue;
  final double averageValue;

  MeasResult({
    required this.measProcIndex,
    required this.isActive,
    required this.counterValue,
    required this.currentValue,
    required this.averageValue,
  });
}
