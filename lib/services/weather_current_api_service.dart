import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mncf_weather/models/weather.dart';

Future<WeatherResponse> fetchWeatherData(location) async {
  const String apiUrl = 'https://api.weatherapi.com/v1/current.json';
  const String apiKey = '439977f78b294cf59cc12549241001';
  const String lang = 'en';
  const String aqi = 'yes';
  final Uri url = Uri.parse('$apiUrl?q=$location&lang=$lang&key=$apiKey&aqi=$aqi');

  try {
    final response = await http.get(url);
    print('weather service query: $location');
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var weatherData = WeatherResponse.fromJson(data);
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