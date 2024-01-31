import 'package:flutter/material.dart';

Image getAssestImage(String path, double width, double height) {
  return Image.asset(
    'assets/$path',
    width: width,
    height: height,
  );
}