import 'package:flutter/material.dart';
import 'package:morning_weather/utils/weather_utils.dart';
import 'package:morning_weather/widgets/home_screen/custom_weather_screen.dart';

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
    {required String asset, required String value, required int isDay, required int code}) {
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
