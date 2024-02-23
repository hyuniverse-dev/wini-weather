import 'package:flutter/material.dart';
import 'package:frino_icons/frino_icons.dart';
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

class AirQualitySectionItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const AirQualitySectionItem({
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

class AirQualitySection extends StatefulWidget {
  final String location;
  final int dayCount;
  static const double columnSpacing = 10.0;

  const AirQualitySection({
    super.key,
    required this.location,
    required this.dayCount,
  });

  @override
  State<AirQualitySection> createState() => _AirQualitySectionState();
}

class _AirQualitySectionState extends State<AirQualitySection> {
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
            'Air Quality',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(height: AirQualitySection.columnSpacing),
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
              // Air Quality Data
              var co = weatherData.current.airQuality.co;
              var o3 = weatherData.current.airQuality.o3;
              var finedust = weatherData.current.airQuality.pm10;
              var ultraFinedust = weatherData.current.airQuality.pm2_5;
              IconData finedustIcon, ultraFinedustIcon, o3Icon;
              Color finedustColor, ultraFinedustColor, o3Color;

              // 미세먼지 분기
              if (finedust >= 100.0) {
                // 나쁨
                finedustIcon = FrinoIcons.f_3d;
                finedustColor = Colors.red;
              } else if (finedust >= 50) {
                // 다소 나쁨
                finedustIcon = FrinoIcons.f_3d;
                finedustColor = Colors.orange;
              } else if (finedust >= 25) {
                // 보통
                finedustIcon = FrinoIcons.f_3d;
                finedustColor = Colors.blue;
              } else {
                // 좋음
                finedustIcon = FrinoIcons.f_3d;
                finedustColor = Colors.green;
              }

              // 초미세먼지 분기
              if (ultraFinedust >= 56.0) {
                ultraFinedustIcon = FrinoIcons.f_3d;
                ultraFinedustColor = Colors.red;
              } else if (ultraFinedust >= 25.0) {
                ultraFinedustIcon = FrinoIcons.f_3d;
                ultraFinedustColor = Colors.orange;
              } else {
                ultraFinedustIcon = FrinoIcons.f_3d;
                ultraFinedustColor = Colors.green;
              }

              // 오존 농도 분기
              if (o3 > 90.0) {
                o3Color = Colors.red;
              } else if (o3 > 30.0) {
                o3Color = Colors.orange;
              } else {
                o3Color = Colors.green;
              }

              var leftColumnItems = [
                DetailItem(
                  icon: finedustIcon, //WeatherIcons.dust,
                  color: finedustColor,
                  title: 'Fine dust',
                  value: '${finedust}',
                ),
                DetailItem(
                  icon: FrinoIcons.f_3d,
                  color: Colors.blueGrey,
                  title: 'CO',
                  value: '${co}',
                ),
              ];

              var rightColumnItems = [
                DetailItem(
                  icon: ultraFinedustIcon,
                  color: ultraFinedustColor,
                  title: 'Ultrafine dust',
                  value: '${ultraFinedust}',
                ),
                DetailItem(
                  icon: FrinoIcons.f_3d,
                  color: o3Color,
                  title: 'OZone',
                  value: '${o3}',
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
              padding: const EdgeInsets.only(
                  bottom: AirQualitySection.columnSpacing),
              child: AirQualitySectionItem(
                icon: item.icon,
                color: item.color,
                title: item.title,
                value: item.value,
              ),
            ))
        .toList();
  }
}
