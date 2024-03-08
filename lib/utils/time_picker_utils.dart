import 'package:flutter/material.dart';

class CustomTimePickerTheme {
  static const String fontFamily = 'Gamja Flower';
  static const TextStyle timePickerTextStyle = TextStyle(
      fontSize: 20, fontFamily: fontFamily, color: Color(0xFF57585E));
  static ThemeData get theme {
    return ThemeData.light().copyWith(
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Color(0xFFF4E7E4),
        hourMinuteTextColor: Colors.black,
        dayPeriodTextColor: Colors.black,
        dayPeriodBorderSide: BorderSide(color: Colors.grey),
        dayPeriodTextStyle: timePickerTextStyle,
        dialHandColor: Color(0xFFEF3B08),
        dialTextColor: Colors.black,
        dialBackgroundColor: Colors.white,
        dialTextStyle: timePickerTextStyle,
        entryModeIconColor: Colors.black,
        helpTextStyle: timePickerTextStyle,
        cancelButtonStyle: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
        confirmButtonStyle: ButtonStyle(
            textStyle: MaterialStateProperty.all(timePickerTextStyle),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
        hourMinuteTextStyle:
            TextStyle(fontSize: 30), // Text style for hours and minutes
      ),
      colorScheme: ColorScheme(
        primary: Colors.white,
        secondary: Colors.white,
        background: Colors.white,
        surface: Colors.white,
        onBackground: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        brightness: Brightness.dark,
        error: Colors.red,
      ),
    );
  }
}
