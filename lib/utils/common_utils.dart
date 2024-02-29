import 'package:flutter/material.dart';
import 'package:mncf_weather/models/details_data.dart';
import 'package:mncf_weather/models/forecast_weather_response.dart';

Image getAssetImage(String path, double width, double height) {
  return Image.asset(
    'assets/$path',
    width: width,
    height: height,
  );
}


// Todo Move to new directory
Widget rowSpace(double interval) {
  return SizedBox(
    width: 10 * interval,
  );
}

// Todo Move to new directory
Widget columnSpace(double interval) {
  return SizedBox(
    height: 10 * interval,
  );
}
