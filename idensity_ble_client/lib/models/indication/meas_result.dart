class MeasResult {
  final int measProcIndex;
  final bool isActive;
  final double currentValue;
  final double averageValue;

  MeasResult({
    required this.measProcIndex,
    required this.isActive,
    required this.currentValue,
    required this.averageValue,
  });
}
