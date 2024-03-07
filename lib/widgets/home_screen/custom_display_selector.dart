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
import 'custom_day_heavysnow.dart';
import 'custom_day_rain.dart';
import 'custom_day_showers.dart';
import 'custom_day_snow.dart';
import 'custom_day_thunder.dart';
import 'custom_day_thundersnow.dart';
import 'custom_night_blizzard.dart';
import 'custom_night_heavyrain.dart';
import 'custom_night_heavysnow.dart';
import 'custom_night_rain.dart';
import 'custom_night_showers.dart';
import 'custom_night_snow.dart';
import 'custom_night_thunder.dart';
import 'custom_night_thunder_snow.dart';

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
    final customSnowScreen = isDay == 1 ? CustomDaySnow() : CustomNightSnow();
    final customBlizzardScreen =
        isDay == 1 ? CustomDayBlizzard() : CustomNightBlizzard();
    final customHeavysnowScreen =
        isDay == 1 ? CustomDayHeavysnow() : CustomNightHeavysnow();
    final customThundersnowScreen =
        isDay == 1 ? CustomDayThundersnow() : CustomNightThundersnow();

    if (code case 1003 || 1006 || 1009) {
      print('displaying customCloudScreen'); // debug
      return customCloudScreen;
    } else if (code case 113 || 1000) {
      print('displaying customSunnyScreen'); // debug
      return customSunnyScreen;
    } else if (code case 1135 || 1147 || 1030) {
      print('displaying customMistScreen'); // debug
      return customMistScreen;
    } else if (code case 1150 || 1072 || 1153 || 1168 || 1171) {
      print('displaying customDrizzleScreen'); // debug
      return customDrizzleScreen;
    } else if (code case 1087 || 1273) {
      print('displaying customThunderScreen'); // debug
      return customThunderScreen;
    } else if (code case 1180 || 1183 || 1186 || 1189 || 1198) {
      print('displaying customRainScreen'); // debug
      return customRainScreen;
    } else if (code
        case 1063 ||
            1240 ||
            1243 ||
            1246 ||
            1066 ||
            1249 ||
            1252 ||
            1261 ||
            1264) {
      print('displaying customShowersScreen'); // debug
      return customShowersScreen;
    } else if (code case 1195 || 1192 || 1201 || 1207 || 1276) {
      print('displaying customHeavyrainScreen'); // debug
      return customHeavyrainScreen;
    } else if (code case 1117 || 1114) {
      print('displaying customBlizzardScreen'); // debug
      return customBlizzardScreen;
    } else if (code case 1069 || 1210 || 1213 || 1204 || 1216 || 1219 || 1255) {
      print('displaying customSnowScreen'); // debug
      return customSnowScreen;
    } else if (code case 1237 || 1222 || 1225 || 1258) {
      print('displaying customHeavysnowScreen'); // debug
      return customHeavysnowScreen;
    } else if (code case 1282 || 1279) {
      print('displaying customThundersnowScreen'); // debug
      return customThundersnowScreen;
    }
    print('displaying default screen'); // debug
    return customThundersnowScreen;
  }

  Color getCustomWeatherBackgroundColor({
    required int code,
  }) {
    if (code case 1003 || 1006 || 1009) {
      print('displaying customCloudScreen'); // debug
      return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
    } else if (code case 113 || 1000) {
      print('displaying customSunnyScreen'); // debug
      return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF57585E);
    } else if (code case 1135 || 1147 || 1030) {
      print('displaying customMistScreen'); // debug
      return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
    } else if (code case 1150 || 1072 || 1153 || 1168 || 1171) {
      print('displaying customDrizzleScreen'); // debug
      return isDay == 1 ? Color(0xFFB9B1AF) : Color(0xFF343438);
    } else if (code case 1087 || 1273) {
      print('displaying customThunderScreen'); // debug
      return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
    } else if (code case 1180 || 1183 || 1186 || 1189 || 1198) {
      print('displaying customRainScreen'); // debug
      return isDay == 1 ? Color(0xFFB9B1AF) : Color(0xFF343438);
    } else if (code
        case 1063 ||
            1240 ||
            1243 ||
            1246 ||
            1066 ||
            1249 ||
            1252 ||
            1261 ||
            1264) {
      print('displaying customShowersScreen'); // debug
      return isDay == 1 ? Color(0xFFB9B1AF) : Color(0xFF343438);
    } else if (code case 1195 || 1192 || 1201 || 1207 || 1276) {
      print('displaying customHeavyrainScreen'); // debug
      return isDay == 1 ? Color(0xFFB9B1AF) : Color(0xFF343438);
    } else if (code case 1117 || 1114) {
      print('displaying customBlizzardScreen'); // debug
      return isDay == 1 ? Color(0xFFBDC1C3) : Color(0xFF2D2C34);
    } else if (code case 1069 || 1210 || 1213 || 1204 || 1216 || 1219 || 1255) {
      print('displaying customSnowScreen'); // debug
      return isDay == 1 ? Color(0xFFBDC1C3) : Color(0xFF2D2C34);
    } else if (code case 1237 || 1222 || 1225 || 1258) {
      print('displaying customHeavysnowScreen'); // debug
      return isDay == 1 ? Color(0xFFBDC1C3) : Color(0xFF2D2C34);
    } else if (code case 1282 || 1279) {
      print('displaying customThundersnowScreen'); // debug
      return isDay == 1 ? Color(0xFFBDC1C3) : Color(0xFF2D2C34);
    }
    return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
  }

  Color getCustomSubContentColor({
    required int code,
  }) {
    // Select the weather screen based on the weather code and time of day
    if (code case 1003 || 1006 || 1009) {
      print('displaying customCloudScreen'); // debug
      return isDay == 1 ? Color(0xFFE9DEDA) : Color(0xFF343438);
    } else if (code case 113 || 1000) {
      print('displaying customSunnyScreen'); // debug
      return isDay == 1 ? Color(0xFFE9DEDA) : Color(0xFF343438);
    } else if (code case 1135 || 1147 || 1030) {
      print('displaying customMistScreen'); // debug
      return isDay == 1 ? Color(0xFFE9DEDA) : Color(0xFF343438);
    } else if (code case 1150 || 1072 || 1153 || 1168 || 1171) {
      print('displaying customDrizzleScreen'); // debug
      return isDay == 1 ? Color(0xFF919191) : Color(0xFF57585E);
    } else if (code case 1087 || 1273) {
      print('displaying customThunderScreen'); // debug
      return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
    } else if (code case 1180 || 1183 || 1186 || 1189 || 1198) {
      print('displaying customRainScreen'); // debug
      return isDay == 1 ? Color(0xFF919191) : Color(0xFF57585E);
    } else if (code
        case 1063 ||
            1240 ||
            1243 ||
            1246 ||
            1066 ||
            1249 ||
            1252 ||
            1261 ||
            1264) {
      print('displaying customShowersScreen'); // debug
      return isDay == 1 ? Color(0xFF919191) : Color(0xFF57585E);
    } else if (code case 1195 || 1192 || 1201 || 1207 || 1276) {
      print('displaying customHeavyrainScreen'); // debug
      return isDay == 1 ? Color(0xFF919191) : Color(0xFF57585E);
    } else if (code case 1117 || 1114) {
      print('displaying customBlizzardScreen'); // debug
      return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF57585E);
    } else if (code case 1069 || 1210 || 1213 || 1204 || 1216 || 1219 || 1255) {
      print('displaying customSnowScreen'); // debug
      return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF57585E);
    } else if (code case 1237 || 1222 || 1225 || 1258) {
      print('displaying customHeavysnowScreen'); // debug
      return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF57585E);
    } else if (code case 1282 || 1279) {
      print('displaying customThundersnowScreen'); // debug
      return isDay == 1 ? Color(0xFFFFF9F6) : Color(0xFF57585E);
    }
    return isDay == 1 ? Color(0xFFE9DEDA) : Color(0xFF343438);
  }
}
