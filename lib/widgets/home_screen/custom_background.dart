import 'package:flutter/material.dart';

Widget getBackgroundImage({required String status}) {
  return Center(
    child: Image.asset(
      'assets/images/backgrounds/${status}_background.png',
      fit: BoxFit.cover,
    ),
  );
}
