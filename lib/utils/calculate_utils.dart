import 'dart:math';
import 'package:realm/realm.dart';

import '../models/location.dart';

List<double> calculateRatios(List<double> values, double base) {
  return values.map((value) {
    final double minTemp = values.reduce(min);
    final double offset = (minTemp < 0) ? -minTemp : 0;

    double adjustTemp = (value + offset) == 0 ? 1 : (value + offset);
    double clampedValue = adjustTemp.clamp(0, base);
    return (clampedValue / base) * 100;
  }).toList();
}

int getNextId(Realm realm, int currentId) {
  var objects = realm.all<Location>();
  var sortedId = objects.map((e) => e.id).toList()..sort();
  for (var id in sortedId) {
    if (id > currentId) {
      return id;
    }
  }
  return -1;
}

List<String> getCurrentWeekday(DateTime dateTime) {
  var now = dateTime;
  final List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  int todayIndex = now.weekday - 1;
  List<String> recorderWeekdays = []
    ..addAll(weekdays.sublist(todayIndex))
    ..addAll(weekdays.sublist(0, todayIndex));

  // recorderWeekdays[0] = 'Today';
  return recorderWeekdays;
}