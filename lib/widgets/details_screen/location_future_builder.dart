import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:morning_weather/models/location_response.dart';

class LocationFutureBuilder extends StatelessWidget {
  final Future<LocationResponse> locationData;

  const LocationFutureBuilder({
    super.key,
    required this.locationData,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: locationData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(),
            Image.asset(
              'assets/images/DogProgress.gif',
              width: 60.0,
              height: 60.0,
            )
          ]);
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final location = snapshot.data!;
          final lat = location.latitude;
          final lon = location.longitude;
          final name = location.name;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "위도: $lat",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "경도: $lon",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "지역명: $name",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        } else {
          return Text("No Data");
        }
      },
    );
  }
}

// Todo Country + borough 표기로 변경
String extractDisplayName(String displayName) {
  String reversed = String.fromCharCodes(displayName.runes.toList());
  String requiredParts = displayName;
  List<String> parts = reversed.split(',');
  if (parts.length > 1) {
    int index = parts.length - 2;
    requiredParts =
        parts.length >= (index) ? parts.sublist(index).join(',') : '';
  }
  return requiredParts;
}
