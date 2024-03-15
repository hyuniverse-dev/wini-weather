import 'package:flutter/material.dart';
import 'package:mncf_weather/models/forecast_weather_response.dart';
import 'package:mncf_weather/services/weather_forecast_api_service.dart';
import 'package:mncf_weather/utils/weather_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'custom_airquality_item.dart';

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

  static const spinkit = SpinKitChasingDots(
    color: Color(0xFFEF3B08),
    size: 26.0,
  );

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
  final bool isLightMode;
  static const double columnSpacing = 10.0;

  const AirQualitySection({
    super.key,
    required this.location,
    required this.dayCount,
    required this.isLightMode,
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
    var textColor = widget.isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF);

    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            'Air Quality',
            style: TextStyle(
              color: textColor,
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
              // return AirQualitySectionItem.spinkit;
              return SizedBox.shrink();
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
                            isLightMode: widget.isLightMode,
                          ),
                          CustomAirQualityItem(
                            asset: '$coAsset',
                            title: 'CO',
                            value: '$coValue',
                            isLightMode: widget.isLightMode,
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
                            isLightMode: widget.isLightMode,
                          ),
                          CustomAirQualityItem(
                            asset: '$oThreeAsset',
                            title: 'OZone',
                            value: '$oThreeValue',
                            isLightMode: widget.isLightMode,
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