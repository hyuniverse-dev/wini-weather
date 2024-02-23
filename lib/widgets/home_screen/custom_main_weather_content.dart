import 'package:flutter/material.dart';

import '../../models/forecast_weather_response.dart';
import '../../utils/common_utils.dart';

Widget buildMainWeatherContent(
    {required bool isCelsius, required ForecastWeatherResponse weatherData}) {
  final forecast = weatherData.forecast.forecastDay[0].day;
  final current = weatherData.current;

  final locationName = weatherData.location.name;
  final highValue = isCelsius ? forecast.maxTempC : forecast.maxTempF;
  final lowValue = isCelsius ? forecast.minTempC : forecast.minTempF;
  final feelsValue = isCelsius ? current.feelsC : current.feelsF;
  final isDay = current.isDay;

  return Positioned(
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            locationName,
            style: TextStyle(
                fontSize: 32.0,
                color: isDay == 1 ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${lowValue.toInt()}',
                style: TextStyle(
                    fontSize: 20.0,
                    color: isDay == 1 ? Colors.grey : Colors.white),
              ),
              rowSpace(1.5),
              Text(
                '${feelsValue.toInt()}',
                style: TextStyle(
                    fontSize: 64.0,
                    fontWeight: FontWeight.bold,
                    color: isDay == 1 ? Colors.black : Colors.white),
              ),
              rowSpace(1.5),
              Text(
                '${highValue.toInt()}',
                style: TextStyle(
                    fontSize: 20.0,
                    color: isDay == 1 ? Colors.grey : Colors.white),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget buildSubWeatherContent({
  required BuildContext context,
  required ForecastWeatherResponse weatherData,
}) {
  final current = weatherData.current;
  final forecast = weatherData.forecast.forecastDay[0].day;
  final isDay = current.isDay;

  // 풍속
  final windKph = current.windKph;
  var windStatus;
  if (windKph >= 62) {
    windStatus = "Very Strong";
  } else if (windKph >= 39) {
    windStatus = "Strong";
  } else if (windKph >= 20) {
    windStatus = "Moderate";
  } else {
    windStatus = "Light";
  }
  var windIcon = "assets/images/wini/wind_${windStatus.toLowerCase().replaceAll(' ', '_')}.png";
  // 습도
  final humidity = current.humidity;
  var humidityStatus;
  if (humidity >= 60) {
    humidityStatus = "High";
  } else if (humidity >= 40) {
    humidityStatus = "Moderate";
  } else {
    humidityStatus = "Low";
  }
  var humidityIcon = "assets/images/wini/humidity_${humidityStatus.toLowerCase()}.png";

  // 강수량
  final dailyChanceOfRain = forecast.dailyChanceOfRain;
  final dailyChanceOfSnow = forecast.dailyChanceOfSnow;
  var dailyStatus = dailyChanceOfRain;
  var dailyResult = "rain";
  if (dailyChanceOfRain == 0) {
    dailyStatus = dailyChanceOfSnow;
    dailyResult = "snow";
  }
  var dailyIcon = "assets/images/wini/${dailyResult}.png";

  // 미세먼지
  final finedust = current.airQuality.pm10;
  var finedustStatus;
  if (finedust >= 100.0) {
    // 나쁨
    finedustStatus = "Poor";
  } else if (finedust >= 50) {
    // 다소 나쁨
    finedustStatus = "Fair";
  } else if (finedust >= 25) {
    // 보통
    finedustStatus = "Moderate";
  } else {
    // 좋음
    finedustStatus = "Good";
  }
  var finedustIcon = "assets/images/wini/fine_dust_${finedustStatus.toLowerCase()}.png";

  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSubWeatherContentItem(
          asset: windIcon,
          value: windStatus,
          isDay: isDay,
        ),
        rowSpace(2.5),
        _buildSubWeatherContentItem(
          asset: humidityIcon,
          value: humidityStatus,
          isDay: isDay,
        ),
        rowSpace(2.5),
        _buildSubWeatherContentItem(
          asset: dailyIcon,
          value: '$dailyStatus%',
          isDay: isDay,
        ),
        rowSpace(2.5),
        _buildSubWeatherContentItem(
          asset: finedustIcon,
          value: finedustStatus,
          isDay: isDay,
        ),
      ],
    ),
  );
}

Widget _buildSubWeatherContentItem(
    {required String asset, required String value, required int isDay}) {
  Color color = isDay == 1 ? Color(0xFFF5EBE8) : Color(0xFF302837);
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              asset,
              width: 25,
            ),
          ],
        ),
      ),
      columnSpace(1),
      Text(
        value,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: isDay == 1 ? Colors.black : Colors.white,
        ),
      ),
    ],
  );
}
