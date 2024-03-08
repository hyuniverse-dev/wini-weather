import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final double? fontSize;
  final bool? isBold;
  final ValueChanged<bool> onChanged;

  const CustomSwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.fontSize,
    this.isBold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
            fontSize: fontSize ?? 18.0,
            fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal),
      ),
      value: value,
      onChanged: onChanged,
      inactiveThumbColor: Color(0xFFFFF9F6),
      inactiveTrackColor: Color(0xFFC5BDBD),
      activeTrackColor: Color(0xFFEB6440),
    );
  }
}
