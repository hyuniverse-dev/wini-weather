import 'package:flutter/material.dart';

Widget CustomDetailsItem({
  required String asset,
  required String title,
  required String value,
  required bool isLightMode,
}) {
  var titleColor = isLightMode ? Color(0xFF57585E) : Color(0xFFE9DEDA);
  var valueColor = isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF);
  var boxDecorationColor = isLightMode ? Color(0xFFE9DEDA) : Color(0xFF343438);
  return Container(
    padding: EdgeInsets.all(18.0),
    margin: EdgeInsets.all(8.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: boxDecorationColor, borderRadius: BorderRadius.circular(8.0)),
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
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  color: valueColor,
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