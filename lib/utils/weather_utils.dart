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
            "assets/images/wini/wind_${status.toLowerCase().replaceAll(" ", "_")}.png",
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
            "assets/images/wini/fine_dust_${status.toLowerCase().replaceAll(" ", "_")}.png",
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
        asset: "assets/images/wini/ultra_fine_dust_${status.toLowerCase()}.png",
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
        asset: "assets/images/wini/co_${status.toLowerCase()}.png",
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
        asset: "assets/images/wini/ozone_${status.toLowerCase()}.png",
        value: '$oThree',
        text: status);
  }

  List<String> getWeeklySkyCondition() {
    List<String> conditions = [];
    for (var days in weatherData.forecast.forecastDay) {
      var code = days.day.condition.code;
      _divisionWeatherCode(code, conditions);
    }
    return conditions;
  }

  List<String> getDailySkyCondition() {
    List<String> conditions = [];
    final forecast = weatherData.forecast.forecastDay;
    for (var days in forecast) {
      for (int i = 0; i < days.hour.length; i += 3) {
        var code = days.hour[i].condition.code;
        _divisionWeatherCode(code, conditions);
      }
    }
    return conditions;
  }

  void _divisionWeatherCode(int code, List<String> conditions) {
    switch (code) {
      case 1117:
        conditions.add("blizzard");
        break;
      case 1003:
        conditions.add("briefly_cloudy");
        break;
      case 1006:
      case 1009:
        conditions.add("cloudy");
        break;
      case 113:
        conditions.add("day_sunny");
        break;
      case 1135:
      case 1147:
      case 1030:
        conditions.add("fog");
        break;
      case 1237:
      case 1261:
      case 1264:
        conditions.add("hail_with_snow");
        break;
      case 1282:
        conditions.add("heavy_snowfall_with_thunder");
        break;
      case 1150:
      case 1153:
      case 1168:
      case 1171:
        conditions.add("light_drizzle");
        break;
      case 1210:
      case 1213:
      case 1255:
        conditions.add("light_snow");
        break;
      case 1087:
      case 1273:
      case 1279:
        conditions.add("lightning");
        break;
      case 1180:
      case 1183:
      case 1186:
      case 1189:
      case 1192:
      case 1195:
      case 1240:
      case 1243:
      case 1246:
        conditions.add("moderate_rain");
        break;
      case 1216:
      case 1219:
      case 1222:
      case 1225:
      case 1258:
        conditions.add("moderate_snow");
        break;
      case 1063:
      case 1066:
      case 1069:
      case 1072:
      case 1249:
      case 1252:
        conditions.add("shower");
        break;
      case 1114:
        conditions.add("strong_wind");
        break;
      case 1276:
        conditions.add("torrential_rain_with_thunder");
        break;
      case 1198:
      case 1201:
      case 1204:
      case 1207:
        conditions.add("torrential_rain");
        break;
      default:
        conditions.add("day_sunny");
    }
  }
}
