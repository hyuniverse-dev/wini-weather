import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomTimePickerTheme {
  final bool isDay;
  static const String fontFamily = 'Gamja Flower';

  TextStyle get timePickerDayStyle =>
      TextStyle(fontSize: 20, fontFamily: fontFamily, color: Color(0xFF57585E));

  TextStyle get timePickerNightStyle =>
      TextStyle(fontSize: 20, fontFamily: fontFamily, color: Color(0xFFFFFFFF));

  Color dayBackgroundColor = Color(0xFFF4E7E4);
  Color nightBackgroundColor = Color(0xFF343438);

  CustomTimePickerTheme({required this.isDay});

  ThemeData get theme {
    final textStyle = isDay ? timePickerDayStyle : timePickerNightStyle;
    final mainColor = isDay ? Color(0xFF000000) : Color(0xFFFFFFFF);
    final backgroundColor = isDay ? Color(0xFFF4E7E4) : Color(0xFF343438);
    final dialBackgroundColor = isDay ? Color(0xFFFFFFFF) : Color(0xFF57585E);
    final primaryContainerColor = isDay ? Color(0xFFFFFFFF) : Color(0xFF57585E);
    final secondaryColor = isDay ? Color(0xFFFFFFFF) : Color(0xFFEF3B08);
    final surfaceColor = isDay ? Color(0xFFFFFFFF) : Color(0xFF57585E);

    return ThemeData.light().copyWith(
      timePickerTheme: TimePickerThemeData(
        backgroundColor: backgroundColor,
        hourMinuteTextColor: mainColor,
        dayPeriodTextColor: mainColor,
        dayPeriodBorderSide: BorderSide(color: Colors.grey),
        dayPeriodTextStyle: textStyle,
        dialHandColor: Color(0xFFEF3B08),
        dialTextColor: mainColor,
        dialBackgroundColor: dialBackgroundColor,
        dialTextStyle: textStyle,
        entryModeIconColor: mainColor,
        helpTextStyle: textStyle,
        cancelButtonStyle: ButtonStyle(
            textStyle: MaterialStateProperty.all(textStyle),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            foregroundColor: MaterialStateProperty.all<Color>(mainColor)),
        confirmButtonStyle: ButtonStyle(
            textStyle: MaterialStateProperty.all(textStyle),
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
            foregroundColor: MaterialStateProperty.all<Color>(mainColor)),
        hourMinuteTextStyle: TextStyle(fontSize: 40),
      ),
      colorScheme: ColorScheme(
        primaryContainer: primaryContainerColor,
        primary: Colors.white,
        secondary: secondaryColor,
        background: Colors.white,
        surface: surfaceColor,
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
