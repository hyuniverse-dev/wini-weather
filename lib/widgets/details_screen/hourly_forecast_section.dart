import 'package:flutter/material.dart';
import 'package:mncf_weather/models/forecast_weather_response.dart';
import 'package:mncf_weather/services/weather_forecast_api_service.dart';
import 'package:mncf_weather/utils/weather_utils.dart';
import 'package:provider/provider.dart';

import '../../screens/settings_screen.dart';
import '../../utils/common_utils.dart';
import '../../utils/math_utils.dart';
import 'custom_bar_graph_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HourlyForecastSection extends StatefulWidget {
  final double base;
  final String location;
  final int dayCount;
  final bool isLightMode;

  const HourlyForecastSection({
    super.key,
    required this.base,
    required this.location,
    required this.dayCount,
    required this.isLightMode,
  });

  @override
  State<HourlyForecastSection> createState() => _HourlyForecastSectionState();
}

class _HourlyForecastSectionState extends State<HourlyForecastSection> {
  static const spinKit = SpinKitChasingDots(
    color: Color(0xFFEF3B08),
    size: 26.0,
  );

  final startHour = 0;
  final interval = 3;

  late ForecastWeatherResponse hourlyWeatherData;
  late ScrollController _scrollController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchForecastWeatherData(widget.location, widget.dayCount).then((data) {
      setState(() {
        hourlyWeatherData = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var textColor = widget.isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hourly Forecast',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child: FutureBuilder<ForecastWeatherResponse>(
              future:
                  fetchForecastWeatherData(widget.location, widget.dayCount),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // return spinkit;
                  return SizedBox.shrink();
                } else if (snapshot.hasError) {
                  return Text('Error == ${snapshot.hasError}');
                } else if (snapshot.hasData) {
                  ForecastWeatherResponse weatherData = snapshot.data!;
                  final forecast = weatherData.forecast.forecastDay;
                  var weather = WeatherUtils(weatherData: weatherData);
                  List<String> skyConditions =
                      weather.getThreeHourlySkyCondition();
                  List<double> tempsC = [];
                  List<double> tempsF = [];
                  print('>>>>> skyConditions.length [${skyConditions.length}]');

                  for (var days in forecast) {
                    for (int i = 0; i < days.hour.length; i += interval) {
                      var hour = days.hour[i];
                      tempsC.add(hour.tempC);
                      tempsF.add(hour.tempF);
                    }
                  }
                  final settingsProvider =
                      Provider.of<SettingsProvider>(context);
                  final isCelsius = settingsProvider.isCelsius;
                  final List<double> tempsRatios =
                      calculateRatios(isCelsius ? tempsC : tempsF, widget.base);

                  return SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        tempsRatios.length,
                        (i) {
                          int time = (startHour + i * interval) % 24;
                          return HourlyForecastSectionItem(
                            temp: isCelsius ? tempsC[i] : tempsF[i],
                            graphValues: tempsRatios[i],
                            asset: skyConditions[i],
                            time: time,
                            isLightMode: widget.isLightMode,
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Text('No Data');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HourlyForecastSectionItem extends StatelessWidget {
  final double temp;
  final double graphValues;
  final String asset;
  final int time;
  final bool isLightMode;

  const HourlyForecastSectionItem({
    super.key,
    required this.temp,
    required this.graphValues,
    required this.asset,
    required this.time,
    required this.isLightMode,
  });

  @override
  Widget build(BuildContext context) {
    var currentHour = DateTime.now().hour;
    final Color pointColor =
        isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF);
    final bool isWithinTimeRange =
        currentHour > (time - 2) && currentHour < (time + 2);

    var iconColor = Color(0xFF919191);
    var tempColor = Color(0xFF919191);
    var timeColor = Color(0xFF6D6D6D);

    if (isWithinTimeRange) {
      iconColor = pointColor;
      tempColor = pointColor;
      timeColor = pointColor;
    }

    return Row(
      children: [
        Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                "${temp.toStringAsFixed(1)}°",
                style: TextStyle(
                  color: tempColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              columnSpace(2.0),
              BarGraphBuilder(
                values: graphValues,
              ),
              columnSpace(2.0),
              getAssetImage('images/weather/$asset.png', 36, 36, iconColor),
              columnSpace(2.0),
              _formatTime(time, timeColor),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget _formatTime(int time, Color color) {
    final int formattedTime = time % 12 == 0 ? 12 : time % 12;
    final String period = time < 12 || time == 24 ? 'AM' : 'PM';
    final formatted = '$period ${formattedTime.toString().padLeft(2, '0')}';
    return Text(formatted,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ));
  }
}
