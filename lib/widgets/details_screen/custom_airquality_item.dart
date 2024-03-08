import 'package:flutter/material.dart';

Widget CustomAirQualityItem({
  required String asset,
  required String title,
  required String value,
  required Color textfieldColor,
  required Color textColor,
}) {
  Color color = Colors.blueGrey;
  return Container(
    padding: EdgeInsets.all(18.0),
    margin: EdgeInsets.all(8.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border.all(
        color: textfieldColor,
        width: 1.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
            Image.asset(
              asset,
              width: 36,
              height: 36,
            ),
          ],
        ),
        Spacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: textfieldColor,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
        Spacer()
      ],
    ),
  );
}
