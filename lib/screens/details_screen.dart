import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/services/weather_forecast_api_service.dart';
import 'package:morning_weather/widgets/details_screen/air_quality_section.dart';
import 'package:morning_weather/widgets/details_screen/details_section.dart';
import 'package:morning_weather/widgets/details_screen/forecast_section.dart';
import 'package:morning_weather/widgets/details_screen/today_section.dart';
import 'package:weather_icons/weather_icons.dart';

import '../utils/date_utils.dart';

class DetailsScreen extends StatefulWidget {
  final String coodinate;

  const DetailsScreen({super.key, required this.coodinate});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final int sensitivity = 30;
  final int day = 1;
  final double base = 30.0;

  late ForecastWeatherResponse hourlyWeatherData;

  int topReachCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchForecastWeatherData(widget.coodinate, day).then((data) {
      setState(() {
        hourlyWeatherData = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener(
          onNotification: _handleScrollNotification,
          child: FutureBuilder<ForecastWeatherResponse>(
            future: fetchForecastWeatherData(widget.coodinate, day),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              } else if (snapshot.hasError) {
                return Text('Error == ${snapshot.error}');
              } else if (snapshot.hasData) {
                return DetailsScreenContent(
                  location: widget.coodinate,
                  base: base,
                );
              } else {
                return Text('No Data');
              }
            },
          ),
        ),
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.minScrollExtent) {
        topReachCount++;
        print(topReachCount);
        if (topReachCount >= 1) {
          Navigator.of(context).pop();
        }
      }
    }
    return true;
  }
}

class DetailsScreenContent extends StatelessWidget {
  final String location;
  final double base;

  const DetailsScreenContent({
    super.key,
    required this.location,
    required this.base,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TodaySection(
              location: location,
              dayCount: 1,
              base: base,
            ),
            SizedBox(
              height: 50.0,
            ),
            ForecastSection(
              weatherIcons: [
                WeatherIcons.cloud,
                WeatherIcons.day_sunny,
                WeatherIcons.sunrise,
                WeatherIcons.day_cloudy_gusts,
                WeatherIcons.day_fog,
                WeatherIcons.cloudy_windy,
                WeatherIcons.day_haze
              ],
              days: getCurrentWeekday(DateTime.now()),
              location: location,
              base: (base - 10.0),
              dayCount: 7,
            ),
            SizedBox(
              height: 50,
            ),
            DetailsSection(
              location: location,
              dayCount: 1,
            ),
            SizedBox(
              height: 50,
            ),
            AirQualitySection(
              location: location,
              dayCount: 1,
            ),
          ],
        ),
      ),
    );
  }
}
