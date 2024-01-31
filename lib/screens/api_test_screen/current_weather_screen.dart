import 'package:flutter/material.dart';

import '../../models/weather.dart';
import '../../services/weather_service.dart';
import '../../widgets/details_screen/weather_future_builder.dart';

class CurrentWeatherScreen extends StatefulWidget {
  const CurrentWeatherScreen({super.key});

  @override
  State<CurrentWeatherScreen> createState() => _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends State<CurrentWeatherScreen> {
  static int weatherFetchCount = 0;
  // String location = '37.5545547,126.9707793';
  String location = '37.5545547,126.9707793';
  TextEditingController searchKeywordController = TextEditingController();
  late Future<WeatherResponse> weatherData;

  @override
  void initState() {
    weatherData = fetchWeatherData(location);
    super.initState();
  }

  void refreshWeather() {
    setState(() {
      weatherData = fetchWeatherData(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CurrentWeatherScreen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WeatherFutureBuilder(
                weatherData: weatherData,
              ),
              ElevatedButton(
                  onPressed: () {
                    refreshWeather();
                    weatherFetchCount++;
                    print("날씨 새로고침 Button ${weatherFetchCount} Clicked");
                  },
                  child: Text("날씨 새로고침")),
            ],
          ),
        ),
      ),
    );
  }
}
