import 'package:flutter/material.dart';

import '../models/details_data.dart';
import '../models/forecast_weather_response.dart';

class WeatherUtils {
  final ForecastWeatherResponse weatherData;

  WeatherUtils({required this.weatherData});

  DetailsData getFeelsLikeData(bool isCelsius) {
    final current = weatherData.current;
    final celsius = current.feelsC;
    final fahrenheit = current.feelsF;
    var status = "Minus";

    if (celsius >= 0.0 || fahrenheit >= 32) {
      status = "Plus";
    }

    return DetailsData(
        asset: "assets/images/wini/temp_${status.toLowerCase()}.png",
        value: '${isCelsius ? celsius : fahrenheit}');
  }

  DetailsData getRainSnowChanceData() {
    final forecast = weatherData.forecast.forecastDay[0].day;
    final rain = forecast.dailyChanceOfRain;
    final snow = forecast.dailyChanceOfSnow;
    var status = "Rain";
    if (rain == 0 && snow != 0) {
      status = "Snow";
    }
    return DetailsData(
        asset: "assets/images/wini/${status.toLowerCase()}.png",
        value: '${status == "Rain" ? rain : snow}',
        more: status == "Rain" ? "Chance Of Rain" : "Chance Of Snow");
  }

  DetailsData getHumidityData() {
    final humidity = weatherData.current.humidity;
    var status = "Low";

    if (humidity >= 60) {
      status = "High";
    } else if (humidity >= 40) {
      status = "Moderate";
    }

    return DetailsData(
        asset: "assets/images/wini/humidity_${status.toLowerCase()}.png",
        value: '$humidity');
  }

  DetailsData getWindSpeedData() {
    final windSpeed = weatherData.current.windKph;
    var status = "Light";

    if (windSpeed >= 62) {
      status = "Very Strong";
    } else if (windSpeed >= 39) {
      status = "Strong";
    } else if (windSpeed >= 20) {
      status = "Moderate";
    }

    return DetailsData(
        asset:
            "assets/images/wini/wind_${status.toLowerCase().replaceAll(" ", "_")}.png",
        value: '$windSpeed');
  }

  DetailsData getWindDirectionData() {
    return DetailsData(
        asset: "", value: '${weatherData.current.windDirection}');
  }

  DetailsData getFinedustData() {
    final finedust = weatherData.current.airQuality.pm10;
    var status = "Good";
    if (finedust >= 100.0) {
      status = "Bad";
    } else if (finedust >= 50) {
      status = "Fairly Bad";
    } else if (finedust >= 25) {
      status = "Moderate";
    }

    return DetailsData(
        asset:
            "assets/images/wini/fine_dust_${status.toLowerCase().replaceAll(" ", "_")}.png",
        value: '$finedust');
  }

  DetailsData getUltraFinedustData() {
    final ultraFinedust = weatherData.current.airQuality.pm2_5;
    var status = "Good";
    if (ultraFinedust >= 56.0) {
      status = "Bad";
    } else if (ultraFinedust >= 25.0) {
      status = "Moderate";
    }

    return DetailsData(
        asset: "assets/images/wini/ultra_fine_dust_${status.toLowerCase()}.png",
        value: '$ultraFinedust');
  }

  DetailsData getCOData() {
    final co = weatherData.current.airQuality.co;
    var status = "Good";
    if (co >= 2300.0) {
      status = "Bad";
    } else if (co >= 1150.0) {
      status = "Moderate";
    }

    return DetailsData(
        asset: "assets/images/wini/co_${status.toLowerCase()}.png",
        value: '$co');
  }

  DetailsData getOThreeData() {
    final oThree = weatherData.current.airQuality.o3;
    var status = "Good";
    if (oThree >= 90.0) {
      status = "Bad";
    } else if (oThree >= 30.0) {
      status = "Moderate";
    }

    return DetailsData(
        asset: "assets/images/wini/ozone_${status.toLowerCase()}.png",
        value: '$oThree');
  }
}
