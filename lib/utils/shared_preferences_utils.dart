import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isNotificationOn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isNotificationOn') ?? false;
}

Future<void> setNotificationOn(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isNotificationOn', value);
}
