import 'dart:ffi';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:morning_weather/models/settings.dart';
import 'package:realm/realm.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationManager() {
    _initializeNotifications();
    tz.initializeTimeZones();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleWeatherNotification() async {
    var hour = 0;
    var minute = 0;
    var config = Configuration.local([Settings.schema]);
    var realm = Realm(config);
    var settings = realm.all<Settings>().lastOrNull;
    if (settings != null) {
      hour = settings.notificationHour;
      minute = settings.notificationMinute;
    }

    final now = DateTime.now();
    final scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '날씨 알림',
        '오늘의 날씨는 맑음, 최고 기온 25도입니다.',
        tzScheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'importance_preview_notification',
            'weather_notification',
            channelDescription: 'This channel is used for weather notification',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}