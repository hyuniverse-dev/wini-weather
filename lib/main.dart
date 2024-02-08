import 'package:flutter/material.dart';
import 'package:morning_weather/models/location_model.dart';
import 'package:morning_weather/screens/home_screen.dart';
import 'package:morning_weather/services/notification_service.dart';
import 'package:morning_weather/utils/geo_utils.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool hasPermission = await requestLocationPermission();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask('importance_preview_notification', 'simplePeriodicTask',
      frequency: Duration(seconds: 1));

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
          child: Text('위치 권한이 필요합니다.'),
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
          NotificationManager();
        }
        break;
    }
    return Future.value(true);
  });
}
