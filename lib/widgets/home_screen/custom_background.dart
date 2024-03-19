import 'package:flutter/material.dart';

Widget getBackgroundImage({required String status, required BuildContext context}) {
  final width = MediaQuery.of(context).size.width;
  print('width = $width');
  final scale = width > 375 ? null : 7.0;
  return Center(
    child: Image.asset(
      'assets/images/backgrounds/${status}_background.png',
      fit: BoxFit.cover,
      scale: scale,
    ),
  );
}