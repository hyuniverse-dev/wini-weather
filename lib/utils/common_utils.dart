import 'package:flutter/material.dart';

Image getAssetImage(String path, double width, double height) {
  return Image.asset(
    'assets/$path',
    width: width,
    height: height,
  );
}

Widget rowSpace(double interval) {
  return SizedBox(
    width: 10 * interval,
  );
}

Widget columnSpace(double interval) {
  return SizedBox(
    height: 10 * interval,
  );
}
