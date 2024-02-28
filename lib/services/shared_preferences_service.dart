import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const _notificationKey = "isNotificationOn";

  Future<bool> getNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationKey) ?? false;
  }

  Future<void> setNotificationStatus(bool value) async {
    print('setNotificationOn >>> $value');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, value);
  }

  Future<void> stopService(ServiceInstance service) async {
    service.stopSelf();
    setNotificationStatus(false);
  }
}
