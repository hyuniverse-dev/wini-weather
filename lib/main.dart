import 'package:flutter/material.dart';
import 'package:morning_weather/models/location_model.dart';
import 'package:morning_weather/screens/home_screen.dart';
import 'package:morning_weather/utils/geolocator_utils.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
