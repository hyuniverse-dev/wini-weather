import 'package:flutter/material.dart';

import '../../models/forecast_weather_response.dart';

class ForecastWeatherBuilder extends StatelessWidget {
  final Future<ForecastWeatherResponse> weatherData;

  const ForecastWeatherBuilder({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(),
            Image.asset(
              'assets/images/DogProgress.gif',
              width: 60.0,
              height: 60.0,
            )
          ]);
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          final weather = snapshot.data!;
          // Weekly H-Temp(7Days)
          List<double> maxTempsC = weather.forecast.forecastDay
              .map((forecastDay) => forecastDay.day.maxTempC)
              .toList();
          print('maxTemps(C): ${maxTempsC.toString()}');

          // Weekly L-Temp(7Days)
          List<double> minTempsC = weather.forecast.forecastDay
              .map((forecastDay) => forecastDay.day.minTempC)
              .toList();
          print('minTemps(C): ${minTempsC.toString()}');

          // Weekly Condition(7Days)
          List<int> conditions = weather.forecast.forecastDay
              .map((forecastDay) => forecastDay.day.condition.code)
              .toList();
          print('conditions: ${conditions.toString()}');
          return Text(
              'Max Temps(7Days): ${maxTempsC.toString()}\n Min Temps(7Days): ${minTempsC.toString()}\n Conditions(7Days): ${conditions}');
        } else {
          return Text('No Data');
        }
      },
    );
  }
}
