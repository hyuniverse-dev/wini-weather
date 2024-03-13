import 'package:flutter/material.dart';

import 'package:mncf_weather/models/forecast_weather_response.dart';
import 'package:mncf_weather/screens/settings_screen.dart';
import 'package:mncf_weather/services/weather_forecast_api_service.dart';
import 'package:mncf_weather/utils/common_utils.dart';
import 'package:mncf_weather/widgets/details_screen/air_quality_section.dart';
import 'package:mncf_weather/widgets/details_screen/details_section.dart';
import 'package:mncf_weather/widgets/details_screen/weekly_forecast_section.dart';
import 'package:mncf_weather/widgets/details_screen/hourly_forecast_section.dart';
import 'package:provider/provider.dart';

import '../utils/date_utils.dart';

class DetailsScreen extends StatefulWidget {
  final String coordinate;
  final bool isLightMode;

  const DetailsScreen(
      {super.key, required this.coordinate, required this.isLightMode});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final int sensitivity = 30;
  final int day = 1;
  final double tTempBase = 35.0;
  final double fTempBase = 100.0;

  late ForecastWeatherResponse hourlyWeatherData;
  late Color backgroundColor = Color(0xFFFFF9F6);

  int topReachCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchForecastWeatherData(widget.coordinate, day).then((data) {
      setState(() {
        hourlyWeatherData = data;
        isLoading = false;
        backgroundColor =
        widget.isLightMode ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isCelsius = settingsProvider.isCelsius;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: NotificationListener(
          onNotification: _handleScrollNotification,
          child: FutureBuilder<ForecastWeatherResponse>(
            future: fetchForecastWeatherData(widget.coordinate, day),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox();
              } else if (snapshot.hasError) {
                return Text('Error == ${snapshot.error}');
              } else if (snapshot.hasData) {
                return DetailsScreenContent(
                  location: widget.coordinate,
                  base: isCelsius ? tTempBase : fTempBase,
                  isLightMode: widget.isLightMode,
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
  final bool isLightMode;

  const DetailsScreenContent({
    super.key,
    required this.location,
    required this.base,
    required this.isLightMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.transparent,
              child: HourlyForecastSection(
                location: location,
                dayCount: 1,
                base: base,
                isLightMode: isLightMode,
              ),
            ),
            columnSpaceWithDivider(3.0, Color(0xFFE9DEDA)),
            WeeklyForecastSection(
              days: getWeekdays(DateTime.now(), true),
              date: getWeekdates(DateTime.now()),
              location: location,
              base: (base - 10.0),
              dayCount: 7,
              isLightMode: isLightMode,
            ),
            columnSpaceWithDivider(3.0, Color(0xFFE9DEDA)),
            DetailsSection(
              location: location,
              dayCount: 1,
              isLightMode: isLightMode,
            ),
            columnSpaceWithDivider(3.0, Color(0xFFE9DEDA)),
            AirQualitySection(
              location: location,
              dayCount: 1,
              isLightMode: isLightMode,
            ),
          ],
        ),
      ),
    );
  }
}