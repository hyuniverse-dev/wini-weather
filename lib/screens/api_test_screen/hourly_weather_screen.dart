import 'package:flutter/material.dart';
import 'package:morning_weather/services/forecast_weather_service.dart';
import 'package:morning_weather/widgets/details_screen/forecast_weather_builder.dart';
import 'package:morning_weather/widgets/details_screen/hourly_weather_builder.dart';

import '../../models/forecast_weather_response.dart';

class HourlyWeatherScreen extends StatefulWidget {
  const HourlyWeatherScreen({super.key});

  @override
  State<HourlyWeatherScreen> createState() => _HourlyWeatherScreenState();
}

class _HourlyWeatherScreenState extends State<HourlyWeatherScreen> {
  String location = '37.5545547,126.9707793';
  bool isLoading = false;
  late Future<ForecastWeatherResponse> weatherData;

  @override
  void initState() {
    weatherData = fetchForecastWeatherData(location, 1);
    super.initState();
  }

  void refreshWeather() async {
    setState(() {
      isLoading = true;
    });
    try {
      weatherData = fetchForecastWeatherData(location, 1);
      await weatherData;
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HourlyWeatherScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isLoading
              ? [CircularProgressIndicator()]
              : [
                  HourlyWeatherBuilder(weatherData: weatherData),
                  ElevatedButton(
                      onPressed: () async {
                        refreshWeather();
                        print(weatherData);
                        print('시간 새로고침 Button Clicked!');
                      },
                      child: Text('시간 새로고침'))
                ],
        ),
      ),
    );
  }
}
