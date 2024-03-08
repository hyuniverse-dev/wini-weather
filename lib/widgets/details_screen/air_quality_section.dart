import 'package:flutter/material.dart';
import 'package:mncf_weather/models/forecast_weather_response.dart';
import 'package:mncf_weather/services/weather_forecast_api_service.dart';
import 'package:mncf_weather/utils/weather_utils.dart';

import 'custom_airquality_item.dart';
import 'custom_details_item.dart';

class DetailItem {
  final IconData icon;
  final Color color;
  final String title;
  final String value;

  const DetailItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
  });
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
  final Color textfieldColor;
  final Color textColor;
  static const double columnSpacing = 10.0;

  const AirQualitySection({
    super.key,
    required this.location,
    required this.dayCount,
    required this.textfieldColor,
    required this.textColor,
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
            style: TextStyle(
              color: widget.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
              final ultrafineDustValue = weather.getUltraFinedustData().value;
              final ultrafineDustAsset = weather.getUltraFinedustData().asset;
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
                          CustomAirQualityItem(
                            asset: '$finedustAsset',
                            title: 'Fine dust',
                            value: '$finedustValue',
                            textfieldColor: widget.textfieldColor,
                            textColor: widget.textColor,
                          ),
                          CustomAirQualityItem(
                            asset: '$coAsset',
                            title: 'CO',
                            value: '$coValue',
                            textfieldColor: widget.textfieldColor,
                            textColor: widget.textColor,
                          )
                        ]),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomAirQualityItem(
                            asset: '$ultrafineDustAsset',
                            title: '     Ultra Dust',
                            value: '$ultrafineDustValue',
                            textfieldColor: widget.textfieldColor,
                            textColor: widget.textColor,
                          ),
                          CustomAirQualityItem(
                            asset: '$oThreeAsset',
                            title: 'OZone',
                            value: '$oThreeValue',
                            textfieldColor: widget.textfieldColor,
                            textColor: widget.textColor,
                          )
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
}
