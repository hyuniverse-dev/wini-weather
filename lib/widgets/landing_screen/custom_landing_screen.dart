import 'package:flutter/material.dart';
import 'package:mncf_weather/utils/common_utils.dart';

import '../../screens/home_screen.dart';
import '../../screens/settings_screen.dart';
import '../../utils/location_permission_utils.dart';

class CustomLandingScreen extends StatefulWidget {
  const CustomLandingScreen({super.key});

  @override
  State<CustomLandingScreen> createState() => _CustomLandingScreenState();
}

class _CustomLandingScreenState extends State<CustomLandingScreen> {
  initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(
        const Duration(seconds: 2), _checkPermissionAndNavigate);
  }

  void _checkPermissionAndNavigate() async {
    bool hasPermission = await requestLocationPermission();
    if (hasPermission) {
      var position = await determinePosition();
      final double latitude = position.latitude;
      final double longitude = position.longitude;
      print("latitude: $latitude, longitude: $longitude"); // debug
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            initialLatitude: latitude,
            initialLongitude: longitude,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(
            isLightMode: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var dateTime = DateTime.now();
    var isDayTime = dateTime.hour > 6 && dateTime.hour < 18;
    // var isDayTime = false;
    return Scaffold(
      backgroundColor: isDayTime ? Color(0xFFFFF9F6) : Color(0xFF1D1F21),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(),
            isDayTime
                ? Image.asset('assets/images/landing/day_landing1.png',
                    width: 206.0, height: 206.0)
                : Image.asset('assets/images/landing/night_landing1.png',
                    width: 206.0, height: 206.0),
            columnSpace(1.0),
            isDayTime
                ? Image.asset(
                    'assets/images/landing/day_landing2.png',
                    width: 39,
                    height: 43,
                  )
                : Image.asset(
                    'assets/images/landing/night_landing2.png',
                    width: 39,
                    height: 43,
                  ),
            columnSpace(1.0),
            isDayTime
                ? Text('Wini\'s Weather',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000)))
                : Text('Wini\'s Weather',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF))),
            columnSpace(15.0),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 63.0,
                  height: 63.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    shape: BoxShape.circle,
                  ),
                ),
                isDayTime
                    ? Image.asset(
                        'assets/images/landing/mncf_logo.png',
                        height: 50.0,
                      )
                    : Image.asset(
                        'assets/images/landing/mncf_logo.png',
                        width: 42.0,
                        height: 42.0,
                      ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
