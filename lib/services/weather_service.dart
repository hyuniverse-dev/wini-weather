import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:morning_weather/models/weather.dart';

Future<WeatherResponse> fetchWeatherData(location) async {
  const String apiUrl = 'https://api.weatherapi.com/v1/current.json';
  const String apiKey = '439977f78b294cf59cc12549241001'; // 여기에 API 키를 넣으세요.
  const String lang = 'ko';
  // const String location = '21.5074456,101.1277653';

  final Uri url = Uri.parse('$apiUrl?q=$location&lang=$lang&key=$apiKey');

  try {
    final response = await http.get(url);
    print('query: $location');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final weatherData = WeatherResponse.fromJson(data);
      // 이곳에서 데이터를 더 처리하거나 UI에 표시할 수 있습니다.
      return weatherData;
    } else {
      throw Exception('날씨 서버 오류: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('HTTP 요청 오류: $e');
  }
}

String decodeUtf8String(String message){
  return utf8.decode(latin1.encode(message));
}