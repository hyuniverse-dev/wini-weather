import 'package:flutter/material.dart';
import 'package:mncf_weather/services/weather_forecast_api_service.dart';
import 'package:mncf_weather/widgets/details_screen/forecast_weather_builder.dart';

import '../../models/forecast_weather_response.dart';

class ForecastWeatherScreen extends StatefulWidget {
  const ForecastWeatherScreen({super.key});

  @override
  State<ForecastWeatherScreen> createState() => _ForecastWeatherScreenState();
}

class _ForecastWeatherScreenState extends State<ForecastWeatherScreen> {
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
        title: Text("ForecastWeatherScreen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isLoading
              ? [CircularProgressIndicator()]
              : [
                  ForecastWeatherBuilder(weatherData: weatherData),
                  ElevatedButton(
                    onPressed: () async {
                      refreshWeather();
                      print(weatherData);
                      print("날씨 새로고침 Button Clicked!");
                    },
                    child: Text("날씨 새로고침"),
                  ),
                ],
        ),
      ),
    );
  }
}
