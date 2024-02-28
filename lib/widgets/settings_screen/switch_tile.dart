import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}