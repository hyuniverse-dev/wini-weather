import 'package:flutter/material.dart';
import 'package:mncf_weather/models/forecast_weather_response.dart';
import 'package:mncf_weather/services/weather_forecast_api_service.dart';
import 'package:mncf_weather/utils/weather_utils.dart';
import 'package:provider/provider.dart';

import '../../screens/settings_screen.dart';
import '../../utils/common_utils.dart';
import '../../utils/math_utils.dart';
import 'custom_bar_graph_builder.dart';

class TodaySection extends StatefulWidget {
  final double base;
  final String location;
  final int dayCount;

  const TodaySection({
    super.key,
    required this.base,
    required this.location,
    required this.dayCount,
  });

  @override
  State<TodaySection> createState() => _TodaySectionState();
}

class _TodaySectionState extends State<TodaySection> {
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
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Center(
            child: FutureBuilder<ForecastWeatherResponse>(
              future:
                  fetchForecastWeatherData(widget.location, widget.dayCount),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error == ${snapshot.hasError}');
                } else if (snapshot.hasData) {
                  ForecastWeatherResponse weatherData = snapshot.data!;
                  final forecast = weatherData.forecast.forecastDay;
                  var weather = WeatherUtils(weatherData: weatherData);
                  List<String> skyConditions = weather.getThreeHourlySkyCondition();
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
                          return TodaySectionItem(
                            temp: isCelsius ? tempsC[i] : tempsF[i],
                            graphValues: tempsRatios[i],
                            asset: skyConditions[i],
                            time: time,
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

class TodaySectionItem extends StatelessWidget {
  final double temp;
  final double graphValues;
  final String asset;
  final int time;

  const TodaySectionItem({
    super.key,
    required this.temp,
    required this.graphValues,
    required this.asset,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                temp.toStringAsFixed(1),
                style: TextStyle(
                  color: Color(0xFF6D6D6D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              columnSpace(2.0),
              BarGraphBuilder(
                values: graphValues,
              ),
              columnSpace(2.0),
              getAssetImage('images/weather/$asset.png', 36, 36),
              columnSpace(2.0),
              _formatTime(time),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Widget _formatTime(int time) {
    final int formattedTime = time % 12 == 0 ? 12 : time % 12;
    final String period = time < 12 || time == 24 ? 'AM' : 'PM';
    final formatted = '$period ${formattedTime.toString().padLeft(2, '0')}';
    return Text(formatted,
        style: TextStyle(
          color: Color(0xFF6D6D6D),
          fontWeight: FontWeight.bold,
        ));
  }
}
