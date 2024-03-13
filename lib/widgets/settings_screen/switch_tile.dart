import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final double? fontSize;
  final bool? isBold;
  final bool isLightMode;
  final ValueChanged<bool> onChanged;

  const CustomSwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.fontSize,
    this.isBold,
    required this.isLightMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textColor = isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF);
    var inactivateThumbColor =
    isLightMode ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF);
    var inactiveTrackColor =
    isLightMode ? Color(0xFFC5BDBD) : Color(0xFF57585E);
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
            color: textColor,
            fontSize: fontSize ?? 18.0,
            fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal),
      ),
      value: value,
      onChanged: onChanged,
      inactiveThumbColor: inactivateThumbColor,
      inactiveTrackColor: inactiveTrackColor,
      activeTrackColor: Color(0xFFEB6440),
    );
  }
}