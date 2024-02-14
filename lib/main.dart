import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:morning_weather/models/location_model.dart';
import 'package:morning_weather/screens/home_screen.dart';
import 'package:morning_weather/services/notification_service.dart';
import 'package:morning_weather/utils/location_permission_utils.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel notificationChannel =
    AndroidNotificationChannel("foreground", "foreground service",
        description: "This is channel foreground notification",
        importance: Importance.high);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initService();
  bool hasPermission = await requestLocationPermission();
  if (hasPermission) {
    var position = await determinePosition();
    final double latitude = position.latitude;
    final double longitude = position.longitude;
    runApp(MyProviderApp(
      latitude: latitude,
      longitude: longitude,
    ));
  } else {
    runApp(MyProviderApp(
      latitude: 38.8950368,
      longitude: -77.0365427,
    ));
  }
}

Future<void> initService() async {
  // set for iOS
  var service = FlutterBackgroundService();
  if (Platform.isIOS) {
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

  // service init and start
  await service.configure(
    iosConfiguration: IosConfiguration(
      onBackground: iOSBackground,
      onForeground: onStart,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: "Schedule Notification",
      initialNotificationTitle: "Today's Weather",
      initialNotificationContent: "Information about weather",
      foregroundServiceNotificationId: 90,
    ),
  );

  print('initService 실행 >>> ');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final currentStatus = prefs.getBool('isNotificationOn');
  print(currentStatus);
  if (currentStatus!) {
    print(currentStatus);
    service.startService();
  }
}

// onstart method
@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool? isNotificationOn = prefs.getBool('isNotificationOn');

  service.on("setAsForeground").listen((event) {});

  service.on("setAsBackground").listen((event) {});

  service.on("stopService").listen((event) {
    service.stopSelf();
  });

  // Display Notification as a Service
  Timer.periodic(Duration(seconds: 5), (timer) async {
    bool currentStatus = prefs.getBool('isNotificationOn') ?? true;
    print("currentStatus >>> $currentStatus");

    if (!currentStatus) {
      return;
    }

    var now = DateTime.now().toLocal();
    var currentTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    await NotificationService().scheduleNotification(
      id: 90,
      title: "Schedule Notification",
      currentTime: currentTime,
    );
    print("background service >> ${currentTime}");
  });
}

// iOSBackground
@pragma("vm:entry-point")
Future<bool> iOSBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

class MyProviderApp extends StatelessWidget {
  final double latitude;
  final double longitude;

  MyProviderApp({
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationModel(
        latitude: latitude,
        longitude: longitude,
      ),
      child: MyApp(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }
}

class PermissionDeniedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Location permission is required.'),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MyApp({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MORNING WEATHER",
      home: MyPage(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }
}

class MyPage extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MyPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      initialLatitude: latitude,
      initialLongitude: longitude,
    );
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case 'simplePeriodicTask':
        final hour = 16;
        final minute = 11;
        final now = DateTime.now();
        print(now);
        print(now.hour);
        print(now.minute);
        if (now.hour == hour && now.minute == minute) {
          // NotificationManager();
        }
        break;
    }
    return Future.value(true);
  });
}
