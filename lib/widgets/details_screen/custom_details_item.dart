import 'package:flutter/material.dart';
import 'package:mncf_weather/utils/common_utils.dart';

Widget CustomDetailsItem({
  required String asset,
  required String title,
  required String value,
}) {
  return Container(
    padding: EdgeInsets.all(18.0),
    margin: EdgeInsets.all(8.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Color(0xFFF7EEEC), borderRadius: BorderRadius.circular(8.0)),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          asset,
          width: 36,
          height: 36,
        ),
        Spacer(),
        Container(
          decoration: BoxDecoration(
              color: Color(0xFFF7EEEC),
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Spacer()
      ],
    ),
  );
}
