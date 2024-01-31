import 'package:flutter/material.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/services/forecast_weather_service.dart';
import 'package:morning_weather/widgets/details_screen/bar_graph_builder.dart';

import '../../../utils/calculate_utils.dart';

class ForecastSection extends StatefulWidget {
  final List<IconData> weatherIcons;
  final List<String> days;
  final String location;
  final double base;
  final int dayCount;

  const ForecastSection({
    super.key,
    required this.weatherIcons,
    required this.days,
    required this.location,
    required this.base,
    required this.dayCount,
  });

  @override
  State<ForecastSection> createState() => _ForecastSectionState();
}

class _ForecastSectionState extends State<ForecastSection> {
  late ForecastWeatherResponse weeklyWeatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchForecastWeatherData(widget.location, widget.dayCount).then((data) {
      setState(() {
        weeklyWeatherData = data;
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
            'Weekly',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: FutureBuilder<ForecastWeatherResponse>(
              future:
                  fetchForecastWeatherData(widget.location, widget.dayCount),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error == ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<double> hTemps = [];
                  List<double> lTemps = [];
                  List<double> tempsDiffer = [];
                  ForecastWeatherResponse weatherData = snapshot.data!;
                  for (var forecastDays in weatherData.forecast.forecastDay) {
                    double maxTemp = forecastDays.day.maxTempC;
                    double minTemp = forecastDays.day.minTempC;
                    hTemps.add(maxTemp);
                    lTemps.add(minTemp);
                    tempsDiffer.add((maxTemp - minTemp).abs());
                  }
                  final List<double> tempsDifferRatios =
                      calculateRatios(tempsDiffer, widget.base);
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < tempsDiffer.length; i++) ...[
                          ForecastSectionItem(
                              icon: widget.weatherIcons[i],
                              highTemp: hTemps[i],
                              lowTemp: lTemps[i],
                              graphValues: tempsDifferRatios[i],
                              day: widget.days[i]),
                          SizedBox(
                            width: 25,
                          )
                        ]
                      ],
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

class ForecastSectionItem extends StatelessWidget {
  final IconData icon;
  final double highTemp;
  final double lowTemp;
  final double graphValues;
  final String day;

  const ForecastSectionItem({
    super.key,
    required this.icon,
    required this.highTemp,
    required this.lowTemp,
    required this.graphValues,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 250,
          child: Column(
            children: [
              Icon(icon),
              Spacer(),
              SizedBox(
                height: 20,
              ),
              Text(highTemp.toStringAsFixed(0)),
              SizedBox(
                height: 5,
              ),
              BarGraphBuilder(values: graphValues),
              SizedBox(
                height: 5,
              ),
              Text(lowTemp.toStringAsFixed(0)),
              SizedBox(
                height: 20,
              ),
              Spacer(),
              Text(
                day,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
