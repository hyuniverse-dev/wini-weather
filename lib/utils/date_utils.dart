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
