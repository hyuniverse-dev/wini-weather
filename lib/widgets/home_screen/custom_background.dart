import 'package:flutter/material.dart';

Widget getBackgroundImage({required String status, required BuildContext context}) {
  final width = MediaQuery.of(context).size.width;
  final scale = width > 750 ? 1.0 : 7.0;
  return Center(
    child: Image.asset(
      'assets/images/backgrounds/${status}_background.png',
      fit: BoxFit.cover,
      scale: scale,
    ),
  );
}
