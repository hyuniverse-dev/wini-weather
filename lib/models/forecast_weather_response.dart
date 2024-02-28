import 'package:morning_weather/models/weather.dart';

class ForecastWeatherResponse extends WeatherResponse {
  final Forecast forecast;

  ForecastWeatherResponse({
    required super.location,
    required super.current,
    required this.forecast,
  });

  factory ForecastWeatherResponse.fromJson(Map<String, dynamic> json) {
    return ForecastWeatherResponse(
      location: Location.fromJson(json['location']),
      current: CurrentWeather.fromJson(json['current']),
      forecast: Forecast.fromJson(json['forecast']),
    );
  }
}

class Forecast {
  List<ForecastDay> forecastDay;

  Forecast({required this.forecastDay});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var list = json['forecastday'] as List;
    List<ForecastDay> forecastDayList =
        list.map((i) => ForecastDay.fromJson(i)).toList();
    return Forecast(
      forecastDay: forecastDayList,
    );
  }

  Map<String, dynamic> toJson() => {
        'forecastday': forecastDay.map((i) => i.toJson()).toList(),
      };
}

class ForecastDay {
  final String date;
  final int dateEpoch;
  final Day day;
  final Astro astro;
  final List<Hour> hour;

  ForecastDay(
      {required this.date,
      required this.dateEpoch,
      required this.day,
      required this.astro,
      required this.hour});

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    var hourList = json['hour'] as List;
    List<Hour> hours = hourList.map((i) => Hour.fromJson(i)).toList();
    return ForecastDay(
      date: json['date'],
      dateEpoch: json['date_epoch'],
      day: Day.fromJson(json['day']),
      astro: Astro.fromJson(json['astro']),
      hour: hours,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'date_epoch': dateEpoch,
        'day': day.toJson(),
        'astro': astro.toJson(),
        'hour': hour.map((i) => i.toJson()).toList(),
      };
}

class Day {
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final double avgTempC;
  final double avgTempF;
  final int dailyChanceOfRain;
  final int dailyChanceOfSnow;
  final WeatherCondition condition;
  // ... 추가 필드가 필요할 수 있음

  Day({
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.dailyChanceOfRain,
    required this.dailyChanceOfSnow,
    required this.condition,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxTempC: json['maxtemp_c'],
      maxTempF: json['maxtemp_f'],
      minTempC: json['mintemp_c'],
      minTempF: json['mintemp_f'],
      avgTempC: json['avgtemp_c'],
      avgTempF: json['avgtemp_f'],
      dailyChanceOfRain: json['daily_chance_of_rain'],
      dailyChanceOfSnow: json['daily_chance_of_snow'],
      condition: WeatherCondition.fromJson(json['condition']),
    );
  }

  Map<String, dynamic> toJson() => {
        'maxtemp_c': maxTempC,
        'maxtemp_f': maxTempF,
        'mintemp_c': minTempC,
        'mintemp_f': minTempF,
        'avgtemp_c': avgTempC,
        'avgtemp_f': avgTempF,
        'daily_chance_of_rain': dailyChanceOfRain,
        'daily_chance_of_snow': dailyChanceOfSnow,
        'condition': condition.toJson(),
      };
}

class Astro {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;
  // ... 추가 필드가 필요할 수 있음

  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    // ... 생성자에 추가 필드 포함
  });

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      // ... JSON에서 추가 필드 추출
    );
  }

  Map<String, dynamic> toJson() => {
        'sunrise': sunrise,
        'sunset': sunset,
        'moonrise': moonrise,
        'moonset': moonset,
        // ... 추가 필드를 JSON으로 변환
      };
}

class Hour {
  final int timeEpoch;
  final String time;
  final double tempC;
  final double tempF;
  final int isDay;
  final WeatherCondition condition;
  // ... 추가 필드가 필요할 수 있음

  Hour({
    required this.timeEpoch,
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    // ... 생성자에 추가 필드 포함
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      timeEpoch: json['time_epoch'],
      time: json['time'],
      tempC: json['temp_c'],
      tempF: json['temp_f'],
      isDay: json['is_day'],
      condition: WeatherCondition.fromJson(json['condition']),
      // ... JSON에서 추가 필드 추출
    );
  }

  Map<String, dynamic> toJson() => {
        'time_epoch': timeEpoch,
        'time': time,
        'temp_c': tempC,
        'temp_f': tempF,
        'is_day': isDay,
        'condition': condition.toJson(),
        // ... 추가 필드를 JSON으로 변환
      };
}

class WeatherCondition {
  final String text;
  final String icon;
  final int code;

  WeatherCondition({
    required this.text,
    required this.icon,
    required this.code,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      text: json['text'],
      icon: json['icon'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'icon': icon,
        'code': code,
      };
}
