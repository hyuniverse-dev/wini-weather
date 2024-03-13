import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mncf_weather/models/location_model.dart';
import 'package:mncf_weather/models/settings.dart';
import 'package:mncf_weather/screens/settings_screen.dart';
import 'package:mncf_weather/services/notification_service.dart';
import 'package:mncf_weather/services/shared_preferences_service.dart';
import 'package:mncf_weather/widgets/landing_screen/custom_landing_screen.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
FlutterLocalNotificationsPlugin();

final SharedPreferencesService sharedPreferencesService =
SharedPreferencesService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initService();
  runApp(MyProviderApp(latitude: 37.5666791, longitude: 126.9782914));
}

Future<void> initService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel notificationChannel =
  AndroidNotificationChannel("foreground", "foreground service",
      description: "This is channel foreground notification",
      importance: Importance.high);

  // if (Platform.isIOS) {
  //   await localNotificationsPlugin.initialize(
  //     const InitializationSettings(
  //       iOS: DarwinInitializationSettings(),
  //     ),
  //   );
  // }
  if (Platform.isIOS || Platform.isAndroid) {
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
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
      autoStart: true,
      onBackground: onIosBackground,
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
  service.startService();
}

@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsforeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsbackground').listen((event) {
      service.setAsBackgroundService();
    });
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  // setupPeriodicTask(service);
  Timer.periodic(Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      var now = DateTime.now().toLocal();
      var currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
      var config = Configuration.local([Settings.schema]);
      var realm = Realm(config);
      await NotificationService(realm).scheduleNotification(
        id: 90,
        title: "Schedule Notification",
        currentTime: currentTime,
      );
      print("background service >> ${currentTime}");
    }
    service.invoke('update');
  });

  var prefs = await sharedPreferencesService.getNotificationStatus();
  Timer? periodicTimer;

  service.on("start").listen((event) async {
    print('startService >>> [실행됨]]'); // debug
    await FlutterBackgroundService().startService();
    await sharedPreferencesService.setNotificationStatus(true);
    service.invoke('update');
    prefs = true;
    setupPeriodicTask(service);
    print("startService >>> ${await FlutterBackgroundService().isRunning()}");
  });

  service.on("stop").listen((event) async {
    print('stopService >>> [실행됨]]'); // debug
    periodicTimer?.cancel();
    await service.stopSelf();
    await sharedPreferencesService.setNotificationStatus(false);
    service.invoke('update');
    prefs = false;
    var isRunning = await FlutterBackgroundService().isRunning();
  });

  print('MainScreen prefs >>> $prefs');
  if (prefs) {
    periodicTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      var now = DateTime.now().toLocal();
      var currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
      var config = Configuration.local([Settings.schema]);
      var realm = Realm(config);
      await NotificationService(realm).scheduleNotification(
        id: 90,
        title: "Schedule Notification",
        currentTime: currentTime,
      );
      print("background service >> ${currentTime}");
    });
  }
}

void setupPeriodicTask(ServiceInstance service) {
  Timer.periodic(Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      var now = DateTime.now().toLocal();
      var currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
      var config = Configuration.local([Settings.schema]);
      var realm = Realm(config);
      await NotificationService(realm).scheduleNotification(
        id: 90,
        title: "Schedule Notification",
        currentTime: currentTime,
      );
      print("background service >> ${currentTime}");
    }
    service.invoke('update');
  });
}

// iOSBackground
@pragma("vm:entry-point")
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  final log = prefs.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationModel(
            latitude: latitude,
            longitude: longitude,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
      ],
      // child: MyApp(
      //   latitude: latitude,
      //   longitude: longitude,
      // ),
      child: MyApp(),
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
  // final double latitude;
  // final double longitude;

  const MyApp({
    super.key,
    // required this.latitude,
    // required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MNCF WEATHER",
      theme: ThemeData(
        fontFamily: 'Gamja Flower',
      ),
      debugShowCheckedModeBanner: false,
      home: CustomLandingScreen(),
      // home: MyPage(
      //   latitude: latitude,
      //   longitude: longitude,
      // ),
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
    return CustomLandingScreen(
      // initialLatitude: latitude,
      // initialLongitude: longitude,
    );
  }
}