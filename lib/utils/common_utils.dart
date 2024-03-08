import 'package:flutter/material.dart';
import 'package:mncf_weather/models/details_data.dart';
import 'package:mncf_weather/models/forecast_weather_response.dart';

Image getAssetImage(String path, double width, double height, Color? color) {
  return Image.asset(
    'assets/$path',
    width: width,
    height: height,
    color: color,
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

Widget columnSpaceWithDivider(double interval, Color color) {
  return Column(
    children: [
      SizedBox(
        height: 10 * (interval * 0.5),
      ),
      Divider(
        color: color,
        thickness: 1,
        // indent: 20,
        // endIndent: 20,
      ),
      SizedBox(
        height: 10 * (interval * 0.5),
      ),
    ],
  );
}

