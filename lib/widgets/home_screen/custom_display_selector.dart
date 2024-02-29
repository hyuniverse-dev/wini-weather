import 'package:flutter/cupertino.dart';
import 'package:mncf_weather/widgets/home_screen/custom_day_cloud.dart';
import 'package:mncf_weather/widgets/home_screen/custom_day_mist.dart';
import 'package:mncf_weather/widgets/home_screen/custom_day_sunny.dart';
import 'package:mncf_weather/widgets/home_screen/custom_night_cloud.dart';
import 'package:mncf_weather/widgets/home_screen/custom_night_mist.dart';
import 'package:mncf_weather/widgets/home_screen/custom_night_sunny.dart';

import '../../models/forecast_weather_response.dart';
import 'custom_day_blizzard.dart';
import 'custom_day_drizzle.dart';
import 'custom_day_heavyrain.dart';
import 'custom_day_rain.dart';
import 'custom_day_showers.dart';
import 'custom_day_thunder.dart';
import 'custom_night_heavyrain.dart';
import 'custom_night_rain.dart';
import 'custom_night_showers.dart';
import 'custom_night_thunder.dart';

Widget buildBackgroundContent({
  required int isDay,
  required ForecastWeatherResponse weatherData,
}) {
  final code = weatherData.current.condition.code;
  print(code);
  var customWeatherScreen =
      CustomWeatherScreen(isDay).getCustomWeatherScreen(code: code);
  return customWeatherScreen;
}

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
    final customDrizzleScreen =
        isDay == 1 ? CustomDayDrizzle() : CustomDayDrizzle();
    final customThunderScreen =
        isDay == 1 ? CustomDayThunder() : CustomNightThunder();
    final customRainScreen = isDay == 1 ? CustomDayRain() : CustomNightRain();
    final customShowersScreen =
        isDay == 1 ? CustomDayShowers() : CustomNightShowers();
    final customHeavyrainScreen =
        isDay == 1 ? CustomDayHeavyrain() : CustomNightHeavyrain();
    final customBlizzardScreen =
        isDay == 1 ? CustomDayBlizzard() : CustomDayBlizzard();

    // if (code case 1117) {
    // } else if (code case 1003 || 1006 || 1009) {
    //   return customCloudScreen;
    // } else if (code case 113) {
    //   return customSunnyScreen;
    // } else if (code case 1135 || 1147 || 1030) {
    //   return customMistScreen;
    // } else if (code case 1150 || 1153 || 1168 || 1171) {
    //   return customDrizzleScreen;
    // } else if (code case 1087 || 1273 || 1279) {
    //   return customThunderScreen;
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
    //   return customRainScreen;
    // } else if (code case 1063 || 1066 || 1069 || 1072 || 1249 || 1252) {
    //   return customShowersScreen;
    // } else if (code case 1198 || 1201 || 1204 || 1207) {
    //   return customHeavyrainScreen;
    // } else if (code case 1210 || 1213 || 1255 || 1216 || 1219 || 1222 || 1225 || 1258) {
    //   return customBlizzardScreen;
    // }


    return customBlizzardScreen;

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

  Color getCustomWeatherBackgroundColor({
    required int code,
  }) {
    // Select the weather screen based on the weather code and time of day

    // if (code case 1117 || 1003 || 1006 || 1009 || 113 || 1135 || 1147 || 1030) {
    //   return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
    // } else if (code case 1150 || 1153 || 1168 || 1171) {
    //   return isDay == 1 ? Color(0xFFB9B1AF) : Color(0xFF343438);
    // } else if (code case 1087 || 1273 || 1279) {
    //   return isDay == 1 ? Color(0xFFB9B1AF) : Color(0xFF343438);
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
    //   return isDay == 1 ? Color(0xFFB9B1AF) : Color(0xFF343438);
    // } else if (code case 1063 || 1066 || 1069 || 1072 || 1249 || 1252) {
    //   return isDay == 1 ? Color(0xFFB9B1AF) : Color(0xFF343438);
    // } else if (code case 1198 || 1201 || 1204 || 1207) {
    //   isDay == 1 ? Color(0xFFB9B1AF) : Color(0xFF2D2C34);
    // }else if (code case 1210 || 1213 || 1255 || 1216 || 1219 || 1222 || 1225 || 1258) {
    //   return isDay == 1 ? Color(0xFFBDC1C3) : Color(0xFF2D2C34);
    // }
    return isDay == 1 ? Color(0xFFBDC1C3) : Color(0xFF2D2C34);

    // TODO: Add more weather conditions
    // if (code case 1237 || 1261 || 1264) {
    //   // conditions.add("hail_with_snow");
    // } else if (code case 1282) {
    //   // conditions.add("heavy_snowfall_with_thunder");
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

  Color getCustomSubContentColor({
    required int code,
  }) {
    // Select the weather screen based on the weather code and time of day

    // if (code case 1117 || 1003 || 1006 || 1009 || 113 || 1135 || 1147 || 1030) {
    //   return isDay == 1 ? Color(0xFFF5EBE8) : Color(0xFF343438);
    // } else if (code case 1150 || 1153 || 1168 || 1171) {
    //   return isDay == 1 ? Color(0xFFF5EBE8) : Color(0xFF343438);
    // } else if (code case 1087 || 1273 || 1279) {
    //   return isDay == 1 ? Color(0xFFF5EBE8) : Color(0xFF343438);
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
    //   return isDay == 1 ? Color(0xFF57585E) : Color(0xFF57585E);
    // } else if (code case 1063 || 1066 || 1069 || 1072 || 1249 || 1252) {
    //   return isDay == 1 ? Color(0xFF57585E) : Color(0xFF57585E);
    // } else if (code case 1198 || 1201 || 1204 || 1207) {
    //   return isDay == 1 ? Color(0xFF57585E) : Color(0xFF57585E);
    // }else if (code case 1210 || 1213 || 1255 || 1216 || 1219 || 1222 || 1225 || 1258) {
  //       return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF57585E);
    // }

    return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF57585E);

    // TODO: Add more weather conditions
    // if (code case 1237 || 1261 || 1264) {
    //   // conditions.add("hail_with_snow");
    // } else if (code case 1282) {
    //   // conditions.add("heavy_snowfall_with_thunder");
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
