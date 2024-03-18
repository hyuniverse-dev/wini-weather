import 'package:flutter/material.dart';

Widget CustomAirQualityItem({
  required BuildContext context,
  required String asset,
  required String title,
  required String value,
  required bool isLightMode,
}) {
  var titleColor = isLightMode ? Color(0xFF57585E) : Color(0xFFE9DEDA);
  var valueColor = isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF);
  var boxDecorationColor = Colors.transparent;
  var borderColor = isLightMode ? Color(0xFFE9DEDA) : Color(0xFF343438);
  final width = MediaQuery.of(context).size.width;
  final fontSize = width > 375 ? 15.0 : 13.0;
  return Container(
    padding: EdgeInsets.all(18.0),
    margin: EdgeInsets.all(8.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: boxDecorationColor,
      border: Border.all(
        color: borderColor,
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
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: fontSize,
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
