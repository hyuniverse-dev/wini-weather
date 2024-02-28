class WeatherResponse {
  final Location location;
  final CurrentWeather current;

  WeatherResponse({
    required this.location,
    required this.current,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: Location.fromJson(json['location']),
      current: CurrentWeather.fromJson(json['current']),
    );
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final double latitude;
  final double longitude;
  final String tzId;
  final int localtimeEpoch;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.tzId,
    required this.localtimeEpoch,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      latitude: json['lat'],
      longitude: json['lon'],
      tzId: json['tz_id'],
      localtimeEpoch: json['localtime_epoch'],
      localtime: json['localtime'],
    );
  }
}

class CurrentWeather {
  final double tempC;
  final double tempF;
  final int isDay;
  final WeatherCondition condition;
  final AirQuality airQuality;
  final double feelsC;
  final double feelsF;
  final double precipMm;
  final double precipIn;
  final int humidity;
  final String windDirection;
  final double windMph;
  final double windKph;
  final String updateTime;

  CurrentWeather({
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.condition,
    required this.airQuality,
    required this.feelsC,
    required this.feelsF,
    required this.precipMm,
    required this.precipIn,
    required this.humidity,
    required this.windDirection,
    required this.windMph,
    required this.windKph,
    required this.updateTime,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: json['temp_c'],
      tempF: json['temp_f'],
      isDay: json['is_day'],
      condition: WeatherCondition.fromJson(json['condition']),
      airQuality: AirQuality.fromJson(json['air_quality']),
      feelsC: json['feelslike_c'],
      feelsF: json['feelslike_f'],
      precipMm: json['precip_mm'],
      precipIn: json['precip_in'],
      humidity: json['humidity'],
      windDirection: json['wind_dir'],
      windMph: json['wind_mph'],
      windKph: json['wind_kph'],
      updateTime: json['last_updated'],
    );
  }
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
}

class AirQuality {
  final double co;
  final double o3;
  final double pm2_5;
  final double pm10;

  AirQuality({
    required this.co,
    required this.o3,
    required this.pm2_5,
    required this.pm10,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    return AirQuality(
      co: json['co'],
      o3: json['o3'],
      pm2_5: json['pm2_5'],
      pm10: json['pm10'],
    );
  }
}
