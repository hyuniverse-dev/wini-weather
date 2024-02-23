import 'package:flutter/material.dart';
import 'package:frino_icons/frino_icons.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/services/weather_forecast_api_service.dart';
import 'package:morning_weather/utils/weahter_utils.dart';

import 'custom_details_item.dart';

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
              var weather = WeatherUtils(weatherData: weatherData);
              final finedustValue = weather.getFinedustData().value;
              final finedustAsset = weather.getFinedustData().asset;
              final ultraFinedustValue = weather.getUltraFinedustData().value;
              final ultraFinedustAsset = weather.getUltraFinedustData().asset;
              final coValue = weather.getCOData().value;
              final coAsset = weather.getCOData().asset;
              final oThreeValue = weather.getOThreeData().value;
              final oThreeAsset = weather.getOThreeData().asset;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDetailsItem(
                            asset: '$finedustAsset',
                            title: 'Feels Like',
                            value: '$finedustValue',
                          ),
                          CustomDetailsItem(
                              asset: '$coAsset', title: 'CO', value: '$coValue')
                        ]),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDetailsItem(
                              asset: '$ultraFinedustAsset',
                              title: 'Ultra Fine dust',
                              value: '$ultraFinedustValue'),
                          CustomDetailsItem(
                              asset: '$oThreeAsset',
                              title: 'OZone',
                              value: '$oThreeValue')
                        ]),
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
