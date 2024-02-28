import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'dart:convert';

Future<ForecastWeatherResponse> fetchForecastWeatherData(coordinate, day) async {
  const String apiUrl = 'https://api.weatherapi.com/v1/forecast.json';
  const String apiKey = '439977f78b294cf59cc12549241001';
  const String aqi = 'yes';
  const String alerts = 'no';
  final int days = day;
  final retries = 3;
  var count = 0;

  final Uri url = Uri.parse(
      '$apiUrl?q=$coordinate&days=$days&aqi=$aqi&alerts=$alerts&key=$apiKey');

  try {
    final response = await http.get(url).timeout(const Duration(seconds: 2));
    print('Start >>> ForecastWeather Request($count)');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final weatherData = ForecastWeatherResponse.fromJson(data);
      final maxTemps =
          weatherData.forecast.forecastDay.map((e) => e.day.maxTempC).toList();
      return weatherData;
    } else {
      throw Exception('날씨 서버 오류: ${response.statusCode}');
    }
  } on TimeoutException catch (e) {
    if  (count < retries){
      count++;
      return fetchForecastWeatherData(coordinate, day);
    }else {
      throw TimeoutException('Request failed after retires');
    }
  } catch (e) {
    throw Exception('HTTP 요청 오류: $e');
  }
}

String decodeUtf8String(String message) {
  return utf8.decode(latin1.encode(message));
}
