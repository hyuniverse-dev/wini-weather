import 'package:flutter/material.dart';
import 'package:mncf_weather/models/forecast_weather_response.dart';
import 'package:mncf_weather/services/weather_forecast_api_service.dart';
import 'package:mncf_weather/utils/common_utils.dart';
import 'package:mncf_weather/utils/weather_utils.dart';
import 'package:mncf_weather/widgets/details_screen/custom_bar_graph_builder.dart';
import 'package:provider/provider.dart';

import '../../screens/settings_screen.dart';
import '../../utils/math_utils.dart';

class WeeklyForecastSection extends StatefulWidget {
  final List<String> days;
  final List<String> date;
  final String location;
  final double base;
  final int dayCount;
  final bool isLightMode;

  const WeeklyForecastSection({
    super.key,
    required this.days,
    required this.date,
    required this.location,
    required this.base,
    required this.dayCount,
    required this.isLightMode,
  });

  @override
  State<WeeklyForecastSection> createState() => _WeeklyForecastSectionState();
}

class _WeeklyForecastSectionState extends State<WeeklyForecastSection> {
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
    var textColor = widget.isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Forecast',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
                  ForecastWeatherResponse weatherData = snapshot.data!;

                  var weather = WeatherUtils(weatherData: weatherData);
                  final settingsProvider =
                      Provider.of<SettingsProvider>(context);
                  final isCelsius = settingsProvider.isCelsius;
                  List<String> skyConditions = weather.getWeeklySkyCondition();
                  List<double> hTemps = [];
                  List<double> lTemps = [];
                  List<double> tempsDiffer = [];

                  for (var forecastDays in weatherData.forecast.forecastDay) {
                    var day = forecastDays.day;
                    double maxTemp = isCelsius ? day.maxTempC : day.maxTempF;
                    double minTemp = isCelsius ? day.minTempC : day.minTempF;
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
                            asset: skyConditions[i],
                            highTemp: hTemps[i],
                            lowTemp: lTemps[i],
                            graphValues: tempsDifferRatios[i],
                            day: widget.days[i],
                            date: widget.date[i],
                            isLightMode: widget.isLightMode,
                          ),
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
  final String asset;
  final double highTemp;
  final double lowTemp;
  final double graphValues;
  final String day;
  final String date;
  final bool isLightMode;

  const ForecastSectionItem({
    super.key,
    required this.asset,
    required this.highTemp,
    required this.lowTemp,
    required this.graphValues,
    required this.day,
    required this.date,
    required this.isLightMode,
  });

  @override
  Widget build(BuildContext context) {
    var tempColor = isLightMode ? Color(0xFF919191) : Color(0xFF919191);
    var dayColor = isLightMode ? Color(0xFF919191) : Color(0xFF919191);
    var dateColor = isLightMode ? Color(0xFF919191) : Color(0xFF919191);
    return Row(
      children: [
        Container(
          height: 250,
          child: Column(
            children: [
              Text(
                day,
                style: TextStyle(
                  color: dayColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              rowSpace(1.0),
              Text(
                date,
                style: TextStyle(
                  color: dateColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              columnSpace(1.0),
              Image.asset(
                'assets/images/wini/$asset.png',
                width: 36.0,
                height: 36.0,
              ),
              Spacer(),
              Text(
                highTemp.toStringAsFixed(0),
                style: TextStyle(
                  color: tempColor,
                ),
              ),
              columnSpace(1.0),
              BarGraphBuilder(values: graphValues),
              columnSpace(1.0),
              Text(
                lowTemp.toStringAsFixed(0),
                style: TextStyle(
                  color: tempColor,
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ],
    );
  }
}
