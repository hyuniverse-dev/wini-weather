import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:morning_weather/models/settings.dart';
import 'package:morning_weather/utils/realm_utils.dart';
import 'package:realm/realm.dart';

class NotificationService {
  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<NotificationDetails> notificationDetails() async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'importance_preview_notification',
      'weather_preview',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentBanner: true,
        presentSound: true);

    const NotificationDetails generalNotificationDetails =
    NotificationDetails(android: androidDetails, iOS: iOSDetails);

    return generalNotificationDetails;
  }

  Future<void> showNotification() async {
    final settings = await fetchSettings();
    final isTemperatureEnabled = settings.isTemperatureEnabled;
    final isFeelsLikeEnabled = settings.isFeelsLikeEnabled;
    final isSkyConditionEnabled = settings.isSkyConditionEnabled;
    final isWindConditionEnabled = settings.isWindConditionEnabled;

    print('showNotification 실행1 >>> ');
    try {
      final generalNotificationDetails = await notificationDetails();
      var notificationTitle = 'Wini\'s Today Weather(Sample)';
      var notificationMessage =
          '\"Prepare an umbrella today!\"\n${isTemperatureEnabled
          ? '#High: 12°C #Low: -1°C'
          : ''} ${isFeelsLikeEnabled
          ? '#Feels: 5°C'
          : ''} ${isSkyConditionEnabled
          ? '#Sky: Clear'
          : ''} ${isWindConditionEnabled ? '#Wind: NNW, 0.4kph' : ''}';
      await localNotificationsPlugin.show(
        1,
        notificationTitle,
        notificationMessage,
        generalNotificationDetails,
      );
      print('showNotification 실행2 >>> ');
    } catch (e) {
      print('showNotification Error >>> $e');
    }
  }

  Future<void> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime currentTime,
  }) async {
    final localNotification = FlutterLocalNotificationsPlugin();
    var config = Configuration.local([Settings.schema]);
    var realm = Realm(config);
    final settings = realm
        .all<Settings>()
        .last;
    final hour = settings.notificationHour;
    final minute = settings.notificationMinute;
    var now = DateTime.now().toLocal();
    var scheduleTime = DateTime(now.year, now.month, now.day, hour, minute);
    var formattedCurrentTime = DateFormat('HH:mm').format(currentTime);
    var formattedScheduleTime = DateFormat('HH:mm').format(scheduleTime);
    print('formattedScheduleTime >>> $formattedScheduleTime');
    print('formattedCurrentTime >>> $formattedCurrentTime');

    if (formattedScheduleTime == formattedCurrentTime) {
      print('Push notification run!');
      showNotification();
    }
  }
}
