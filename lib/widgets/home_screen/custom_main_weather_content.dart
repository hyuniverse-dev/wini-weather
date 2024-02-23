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
