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
    await Future.delayed(const Duration(milliseconds: 2500), _checkPermissionAndNavigate);
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
    // var isDayTime = true;
    return Scaffold(
      backgroundColor: isDayTime ? Color(0xFFFFF9F6) : Color(0xFF1D1F21),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: <Widget>[
                  Spacer(),
                  isDayTime
                      ? Image.asset(
                          'assets/images/landing/day_landing2.png',
                        )
                      : Image.asset(
                          'assets/images/landing/night_landing3.png',
                        ),
                  columnSpace(2.0),
                  isDayTime
                      ? Image.asset(
                          'assets/images/landing/day_landing1.png',
                        )
                      : Image.asset(
                          'assets/images/landing/night_landing2.png',
                        ),
                ],
              ),
            ),
            Spacer(),
            isDayTime
                ? Image.asset(
                    'assets/images/landing/day_landing3.png',
                    height: 50.0,
                  )
                : Text(
                    'Web3D market',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
