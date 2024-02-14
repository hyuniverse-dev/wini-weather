import 'package:flutter/material.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/services/weather_forecast_api_service.dart';

import '../../utils/image_utils.dart';
import '../../utils/math_utils.dart';
import 'bar_graph_builder.dart';

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
                  List<double> tempsC = [];
                  List<double> tempsF = [];
                  ForecastWeatherResponse weatherData = snapshot.data!;
                  for (var forecastDays in weatherData.forecast.forecastDay) {
                    for (int i = 0; i < forecastDays.hour.length; i += 3) {
                      var hour = forecastDays.hour[i];
                      tempsC.add(hour.tempC);
                      tempsF.add(hour.tempF);
                    }
                  }
                  final List<double> tempsRatios =
                      calculateRatios(tempsC, widget.base);
                  return SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        tempsRatios.length,
                        (i) {
                          int time = (startHour + i * interval) % 24;
                          return TodaySectionItem(
                            temp: tempsC[i],
                            graphValues: tempsRatios[i],
                            iconNum: (i < 10) ? i + 1 : (i % 10) + 1,
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
  final int iconNum;
  final int time;

  const TodaySectionItem({
    super.key,
    required this.temp,
    required this.graphValues,
    required this.iconNum,
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
              Text(temp.toStringAsFixed(1)),
              SizedBox(
                height: 20,
              ),
              BarGraphBuilder(
                values: graphValues,
              ),
              // TweenAnimationBuilder(
              //   tween: Tween<double>(begin: 0.3, end: 1.0),
              //   duration: Duration(milliseconds: 1000),
              //   builder: (context, double scale, child) {
              //     return Transform.scale(
              //       scale: scale,
              //       child: BarGraphBuilder(
              //         values: graphValues,
              //       ),
              //     );
              //   },
              // ),
              SizedBox(
                height: 20,
              ),
              getAssestImage('images/Member${iconNum}.png', 40, 40),
              SizedBox(
                height: 20,
              ),
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
    print('$period ${formattedTime.toString().padLeft(2, '0')}');
    return Text('$period ${formattedTime.toString().padLeft(2, '0')}');
  }
}
