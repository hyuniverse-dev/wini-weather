import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mncf_weather/utils/weather_utils.dart';
import 'package:mncf_weather/widgets/home_screen/custom_display_selector.dart';

import '../../models/forecast_weather_response.dart';
import '../../utils/common_utils.dart';

Widget buildMainWeatherContent(
    {required BuildContext context,
    required bool isCelsius,
    required ForecastWeatherResponse weatherData}) {
  final forecast = weatherData.forecast.forecastDay[0].day;
  final current = weatherData.current;

  final locationName = weatherData.location.name;
  final highValue = isCelsius ? forecast.maxTempC : forecast.maxTempF;
  final lowValue = isCelsius ? forecast.minTempC : forecast.minTempF;
  final feelsValue = isCelsius ? current.feelsC : current.feelsF;
  final isDay = current.isDay;
  final titleColor = isDay == 1 ? Color(0xFF000000) : Color(0xFFFFFFFF);
  final color = isDay == 1 ? Color(0xFF57585E) : Color(0xFFFFFFFF);
  return Positioned(
    top: 0,
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Text(
            locationName,
            style: TextStyle(
                fontSize: 32.0, color: titleColor, fontWeight: FontWeight.bold),
          ),
          columnSpace(1.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Spacer(),
              _buildTemperatureContent(
                  value: lowValue,
                  color: color,
                  fontSize: 20.0,
                  offset: Offset(-6.0, 3.0)),
              rowSpace(2.0),
              _buildTemperatureContent(
                  value: feelsValue,
                  color: titleColor,
                  fontSize: 64.0,
                  offset: Offset(-17.0, 15.0)),
              rowSpace(1.0),
              _buildTemperatureContent(
                  value: highValue,
                  color: color,
                  fontSize: 20.0,
                  offset: Offset(-6.0, 3.0)),
              Spacer(),
            ],
          )
        ],
      ),
    ),
  );
}

Widget _buildTemperatureContent(
    {required double value,
    required Color color,
    required double fontSize,
    required Offset offset}) {
  return FittedBox(
    fit: BoxFit.contain,
    child: RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '${value.toInt()}°',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.0,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildSubWeatherContent({
  required BuildContext context,
  required ForecastWeatherResponse weatherData,
}) {
  var weather = WeatherUtils(weatherData: weatherData);
  final current = weatherData.current;
  final isDay = current.isDay;
  final code = current.condition.code;
  final windSpeedValue = weather.getWindSpeedData().value;
  final windSpeedAsset = weather.getWindSpeedData().asset;
  final windSpeedText = weather.getWindSpeedData().text;
  final humidityValue = weather.getHumidityData().value;
  final humidityAsset = weather.getHumidityData().asset;
  final humidityText = weather.getHumidityData().text;
  final rainSnowChanceValue = weather.getRainSnowChanceData().value;
  final rainSnowChanceAsset = weather.getRainSnowChanceData().asset;
  final finedustValue = weather.getFinedustData().value;
  final finedustAsset = weather.getFinedustData().asset;
  final finedustText = weather.getFinedustData().text;
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSubWeatherContentItem(
          asset: windSpeedAsset,
          value: windSpeedText!,
          isDay: isDay,
          code: code,
        ),
        rowSpace(2.5),
        _buildSubWeatherContentItem(
          asset: humidityAsset,
          value: humidityText!,
          isDay: isDay,
          code: code,
        ),
        rowSpace(2.5),
        _buildSubWeatherContentItem(
          asset: rainSnowChanceAsset,
          value: '$rainSnowChanceValue%',
          isDay: isDay,
          code: code,
        ),
        rowSpace(2.5),
        _buildSubWeatherContentItem(
          asset: finedustAsset,
          value: finedustText!,
          isDay: isDay,
          code: code,
        ),
      ],
    ),
  );
}

Widget _buildSubWeatherContentItem(
    {required String asset,
    required String value,
    required int isDay,
    required int code}) {
  // Color color = isDay == 1 ? Color(0xFFF5EBE8) : Color(0xFF343438);
  final color = CustomWeatherScreen(isDay).getCustomSubContentColor(code: code);
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Image.asset(
            asset,
            height: 36,
            width: 36,
          ),
        ],
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
