import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:morning_weather/models/settings.dart';
import 'package:morning_weather/services/settings_data_service.dart';
import 'package:realm/realm.dart';

class NotificationService {
  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final Realm realm;

  NotificationService(this.realm);

  Future<void> init() async {
    final initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
        macOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ));

    await localNotificationsPlugin.initialize(initSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'importance_preview_notification', 'weather_preview',
        description: 'This channel is used for weather preview',
        importance: Importance.high);

    localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

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
    SettingsDataService settingsDataService = SettingsDataService(realm);
    final settings = await settingsDataService.fetchSettings();
    final isTemperatureEnabled = settings.isTemperatureEnabled;
    final isFeelsLikeEnabled = settings.isFeelsLikeEnabled;
    final isSkyConditionEnabled = settings.isSkyConditionEnabled;
    final isWindConditionEnabled = settings.isWindConditionEnabled;

    print('showNotification 실행1 >>> ');
    try {
      final generalNotificationDetails = await notificationDetails();
      var notificationTitle = 'Wini\'s Today Weather (Sample)';
      var notificationMessage =
          '\"Prepare an umbrella today!\"\n${isTemperatureEnabled ? '#High: 12°C #Low: -1°C' : ''} ${isFeelsLikeEnabled ? '#Feels: 5°C' : ''} ${isSkyConditionEnabled ? '#Sky: Clear' : ''} ${isWindConditionEnabled ? '#Wind: NNW, 0.4kph' : ''}';
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
    required TimeOfDay currentTime,
  }) async {
    final localNotification = FlutterLocalNotificationsPlugin();
    final settings = realm.all<Settings>().last;
    var scheduleTime = TimeOfDay(hour: settings.notificationHour, minute: settings.notificationMinute);
    final isSameHour = scheduleTime.hour == currentTime.hour;
    final isSameMinute = scheduleTime.minute == currentTime.minute;
    print('scheduleTime >>> $scheduleTime');
    print('currentTime >>> $currentTime');

    if (isSameHour && isSameMinute) {
      print('Push notification run!');
      showNotification();
    }
  }
}
