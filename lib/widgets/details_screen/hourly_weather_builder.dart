import 'package:flutter/material.dart';

import '../../models/forecast_weather_response.dart';

class HourlyWeatherBuilder extends StatelessWidget {
  final Future<ForecastWeatherResponse> weatherData;

  const HourlyWeatherBuilder({
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
          List<Iterable<String>> times = weather.forecast.forecastDay
              .map((forecastDay) => forecastDay.hour.map((hour) => hour.time))
              .toList();

          var firstDayTimes = times.first;

          // Todo decision about next day hourly temperature
          List<String> today = [];
          firstDayTimes.forEach((element) {
            int hour = int.parse(element.substring(11, 13));
            if (hour % 3 == 0) {
              today.add(element);
            }
          });

          print('today: ${today}');

          return Text('Interval three hours : ${today}');
        }
        return Text('No Data');
      },
    );
  }
}
