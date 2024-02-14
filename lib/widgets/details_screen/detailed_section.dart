import 'package:flutter/material.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/services/weather_forecast_api_service.dart';

class DetailItem {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const DetailItem(
      {required this.icon,
      required this.color,
      required this.title,
      required this.value});
}

class DetailedSectionItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const DetailedSectionItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 50.0),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 20)),
          ],
        ),
      ],
    );
  }
}

class DetailedSection extends StatefulWidget {
  final String location;
  final int dayCount;
  static const double columnSpacing = 10.0;

  const DetailedSection({
    super.key,
    required this.location,
    required this.dayCount,
  });

  @override
  State<DetailedSection> createState() => _DetailedSectionState();
}

class _DetailedSectionState extends State<DetailedSection> {
  late ForecastWeatherResponse detailsWeatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchForecastWeatherData(widget.location, widget.dayCount).then((data) {
      setState(() {
        detailsWeatherData = data;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            'Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(height: DetailedSection.columnSpacing),
        FutureBuilder<ForecastWeatherResponse>(
          future: fetchForecastWeatherData(
            widget.location,
            widget.dayCount,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error == ${snapshot.error}');
            } else if (snapshot.hasData) {
              ForecastWeatherResponse weatherData = snapshot.data!;
              var feelsC = weatherData.current.feelsC;
              var humidity = weatherData.current.humidity;
              var windDirection = weatherData.current.windDirection;
              var windKph = weatherData.current.windKph;
              var dailyChanceOfRain;
              var dailyChanceOfSnow;
              var dailyChanceOf;
              var dailyChanceOfTitle;
              IconData dailyChanceOfIcon;
              var color;

              for (var forecastDays in weatherData.forecast.forecastDay) {
                dailyChanceOfRain = forecastDays.day.dailyChanceOfRain;
                dailyChanceOfSnow = forecastDays.day.dailyChanceOfSnow;
              }

              // Details Element Branching Based on the Possibility of Snow
              if (dailyChanceOfSnow > 0.0) {
                dailyChanceOf = dailyChanceOfSnow;
                dailyChanceOfIcon = Icons.snowing;
                dailyChanceOfTitle = 'Chance Of Snow';
              }else {
                dailyChanceOf = dailyChanceOfRain;
                dailyChanceOfIcon = Icons.grain;
                dailyChanceOfTitle = 'Chance Of Rain';
              }

              // Temperature Gauge Color Division Based on Perceived Temperature
              if (feelsC > 25.0) {
                color = Colors.red;
              }else if(feelsC > 15.0) {
                color = Colors.orangeAccent;
              }else if(feelsC > 0.0) {
                color = Colors.lightGreen;
              }else{
                color = Colors.blue;
              }




              var leftColumnItems = [
                DetailItem(
                  icon: Icons.thermostat_outlined,
                  color: color,
                  title: 'Feels Like',
                  value: '$feelsC',
                ),
                DetailItem(
                  icon: Icons.water_drop_outlined,
                  color: Colors.blueGrey,
                  title: 'Humidity',
                  value: '$humidity',
                ),
              ];

              var rightColumnItems = [
                DetailItem(
                  icon: dailyChanceOfIcon,
                  color: Colors.blueGrey,
                  title: dailyChanceOfTitle,
                  value: '$dailyChanceOf',
                ),
                DetailItem(
                  icon: Icons.explore_outlined,
                  color: Colors.blueGrey,
                  title: 'Wind \"${windDirection}\"',
                  value: '$windKph',
                ),
              ];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildDetailItems(leftColumnItems),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildDetailItems(rightColumnItems),
                  ),
                ],
              );
            } else {
              return Text('No Data');
            }
          },
        ),
      ],
    );
  }

  List<Widget> _buildDetailItems(List<DetailItem> items) {
    return items
        .map((item) => Padding(
              padding:
                  const EdgeInsets.only(bottom: DetailedSection.columnSpacing),
              child: DetailedSectionItem(
                icon: item.icon,
                color: item.color,
                title: item.title,
                value: item.value,
              ),
            ))
        .toList();
  }
}
