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
        asset: "assets/images/icons/temp_${status.toLowerCase()}.png",
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
        asset: "assets/images/icons/${status.toLowerCase()}.png",
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
        asset: "assets/images/icons/humidity_${status.toLowerCase()}.png",
        value: '$humidity',
        text: status);
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
            "assets/images/icons/wind_${status.toLowerCase().replaceAll(" ", "_")}.png",
        value: '$windSpeed',
        text: status);
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
            "assets/images/icons/fine_dust_${status.toLowerCase().replaceAll(" ", "_")}.png",
        value: '$finedust',
        text: status);
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
        asset:
            "assets/images/icons/ultra_fine_dust_${status.toLowerCase()}.png",
        value: '$ultraFinedust',
        text: status);
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
        asset: "assets/images/icons/co_${status.toLowerCase()}.png",
        value: '$co',
        text: status);
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
        asset: "assets/images/icons/ozone_${status.toLowerCase()}.png",
        value: '$oThree',
        text: status);
  }

  List<String> getWeeklySkyCondition() {
    List<String> conditions = [];
    for (var days in weatherData.forecast.forecastDay) {
      var code = days.day.condition.code;
      divisionWeatherCodeToText(code, conditions);
    }
    return conditions;
  }

  List<String> getThreeHourlySkyCondition() {
    List<String> conditions = [];
    final forecast = weatherData.forecast.forecastDay;
    for (var days in forecast) {
      for (int i = 0; i < days.hour.length; i += 3) {
        var code = days.hour[i].condition.code;
        divisionWeatherCodeToText(code, conditions);
      }
    }
    return conditions;
  }
}

void divisionWeatherCodeToText(int code, List<String> conditions) {
  if (code case 1117) {
    conditions.add("blizzard");
  } else if (code case 1003) {
    conditions.add("briefly_cloudy");
  } else if (code case 1006 || 1009) {
    conditions.add("cloudy");
  } else if (code case 113) {
    conditions.add("day_sunny");
  } else if (code case 1135 || 1147 || 1030) {
    conditions.add("fog");
  } else if (code case 1237 || 1261 || 1264) {
    conditions.add("hail_with_snow");
  } else if (code case 1282) {
    conditions.add("heavy_snowfall_with_thunder");
  } else if (code case 1150 || 1153 || 1168 || 1171) {
    conditions.add("light_drizzle");
  } else if (code case 1210 || 1213 || 1255) {
    conditions.add("light_snow");
  } else if (code case 1087 || 1273 || 1279) {
    conditions.add("lightning");
  } else if (code
      case 1180 ||
          1183 ||
          1186 ||
          1189 ||
          1192 ||
          1195 ||
          1240 ||
          1243 ||
          1246) {
    conditions.add("moderate_rain");
  } else if (code case 1216 || 1219 || 1222 || 1225 || 1258) {
    conditions.add("moderate_snow");
  } else if (code case 1063 || 1066 || 1069 || 1072 || 1249 || 1252) {
    conditions.add("shower");
  } else if (code case 1114) {
    conditions.add("strong_wind");
  } else if (code case 1276) {
    conditions.add("torrential_rain_with_thunder");
  } else if (code case 1198 || 1201 || 1204 || 1207) {
    conditions.add("torrential_rain");
  } else {
    conditions.add("day_sunny");
  }
}
