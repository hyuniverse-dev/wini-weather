import 'package:flutter/material.dart';

Widget daySunnyBackground() {
  return Center(
    child: Image.asset(
      'assets/images/backgrounds/day_sunny_content.png',
      fit: BoxFit.cover,
    ),
  );
}

Widget nightSunnyBackground() {
  return Center(
    child: Image.asset(
      'assets/images/backgrounds/night_sunny_content.png',
      fit: BoxFit.cover,
    ),
  );
}

Widget dayCloudBackground(){
  return Center(
    child: Image.asset(
      'assets/images/backgrounds/day_cloud_background.png',
      fit: BoxFit.cover,
    ),
  );
}

Widget nightCloudBackground(){
  return Center(
    child: Image.asset(
      'assets/images/backgrounds/night_cloud_background.png',
      fit: BoxFit.cover,
    ),
  );
}

Widget dayMistBackground(){
  return Center(
    child: Image.asset(
      'assets/images/backgrounds/day_mist_background.png',
      fit: BoxFit.cover,
    ),
  );
}