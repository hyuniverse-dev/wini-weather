import 'dart:math';

List<double> calculateRatios(List<double> values, double base) {
  return values.map((value) {
    final double minTemp = values.reduce(min);
    final double offset = (minTemp < 0) ? -minTemp : 0;

    double adjustTemp = (value + offset) == 0 ? 1 : (value + offset);
    double clampedValue = adjustTemp.clamp(0, base);
    return (clampedValue / base) * 100;
  }).toList();
}
