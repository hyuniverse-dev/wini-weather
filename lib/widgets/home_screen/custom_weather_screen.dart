import 'package:flutter/cupertino.dart';
import 'package:morning_weather/widgets/home_screen/custom_day_cloud.dart';
import 'package:morning_weather/widgets/home_screen/custom_day_mist.dart';
import 'package:morning_weather/widgets/home_screen/custom_day_sunny.dart';
import 'package:morning_weather/widgets/home_screen/custom_night_cloud.dart';
import 'package:morning_weather/widgets/home_screen/custom_night_mist.dart';
import 'package:morning_weather/widgets/home_screen/custom_night_sunny.dart';

class CustomWeatherScreen {
  final int isDay;

  CustomWeatherScreen(this.isDay);

  Widget getCustomWeatherScreen({
    required int code,
  }) {
    // Select the weather screen based on the weather code and time of day
    final customSunnyScreen =
        isDay == 1 ? CustomDaySunny() : CustomNightSunny();
    final customCloudScreen =
        isDay == 1 ? CustomDayCloud() : CustomNightCloud();
    final customMistScreen = isDay == 1 ? CustomDayMist() : CustomNightMist();

    if (code case 1117) {
    } else if (code case 1003 || 1006 || 1009) {
      return customCloudScreen;
    } else if (code case 113) {
      return customSunnyScreen;
    } else if (code case 1135 || 1147 || 1030) {
      return customMistScreen;
    }
    return customSunnyScreen;

    // TODO: Add more weather conditions
    // else if (code case 1237 || 1261 || 1264) {
    //   // conditions.add("hail_with_snow");
    // } else if (code case 1282) {
    //   // conditions.add("heavy_snowfall_with_thunder");
    // } else if (code case 1150 || 1153 || 1168 || 1171) {
    //   // conditions.add("light_drizzle");
    // } else if (code case 1210 || 1213 || 1255) {
    //   // conditions.add("light_snow");
    // } else if (code case 1087 || 1273 || 1279) {
    //   // conditions.add("lightning");
    // } else if (code
    //     case 1180 ||
    //         1183 ||
    //         1186 ||
    //         1189 ||
    //         1192 ||
    //         1195 ||
    //         1240 ||
    //         1243 ||
    //         1246) {
    //   // conditions.add("moderate_rain");
    // } else if (code case 1216 || 1219 || 1222 || 1225 || 1258) {
    //   // conditions.add("moderate_snow");
    // } else if (code case 1063 || 1066 || 1069 || 1072 || 1249 || 1252) {
    //   // conditions.add("shower");
    // } else if (code case 1114) {
    //   // conditions.add("strong_wind");
    // } else if (code case 1276) {
    //   // conditions.add("torrential_rain_with_thunder");
    // } else if (code case 1198 || 1201 || 1204 || 1207) {
    //   // conditions.add("torrential_rain");
    // }
  }
}
