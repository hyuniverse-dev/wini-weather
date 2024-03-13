import 'package:intl/intl.dart';

List<String> getWeekdays(DateTime dateTime, bool isToday) {
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
  if (isToday) {
    recorderWeekdays[0] = 'Today';
  }
  return recorderWeekdays;
}

List<String> getWeekdates(DateTime dateTime) {
  List<String> dates = [];
  for (int i = 0; i < 7; i++) {
    DateTime date = dateTime.add(Duration(days: i));
    String formattedDate = DateFormat('M.dd').format(date);
    dates.add(formattedDate);
  }
  return dates;
}

List<String> getMinSeconds(DateTime dateTime){
  List<String> minSeconds = [];
  for (int i = 0; i < 24; i++) {
    DateTime date = dateTime.add(Duration(hours: i));
    String formattedDate = DateFormat('hh:mm a').format(date);
    minSeconds.add(formattedDate);
  }
  return minSeconds;
}