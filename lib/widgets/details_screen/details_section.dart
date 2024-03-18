import 'package:flutter/material.dart';
import 'package:mncf_weather/models/forecast_weather_response.dart';
import 'package:mncf_weather/screens/settings_screen.dart';
import 'package:mncf_weather/services/weather_forecast_api_service.dart';
import 'package:mncf_weather/utils/common_utils.dart';
import 'package:mncf_weather/utils/weather_utils.dart';
import 'package:provider/provider.dart';
import 'custom_details_item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DetailsSection extends StatefulWidget {
  static const double columnSpacing = 10.0;
  static const spinkit = SpinKitChasingDots(
    color: Color(0xFFEF3B08),
    size: 26.0,
  );

  final String location;
  final int dayCount;
  final bool isLightMode;

  const DetailsSection({
    super.key,
    required this.location,
    required this.dayCount,
    required this.isLightMode,
  });

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
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
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isCelsius = settingsProvider.isCelsius;
    var textColor = widget.isLightMode ? Color(0xFF000000) : Color(0xFFFFFFFF);
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            'Details',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        columnSpace(3.0),
        FutureBuilder<ForecastWeatherResponse>(
          future: fetchForecastWeatherData(
            widget.location,
            widget.dayCount,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // return DetailsSection.spinkit;
              return SizedBox.shrink();
            } else if (snapshot.hasError) {
              return Text('Error == ${snapshot.error}');
            } else if (snapshot.hasData) {
              ForecastWeatherResponse weatherData = snapshot.data!;
              var weather = WeatherUtils(weatherData: weatherData);
              final feelsLikeValue = weather.getFeelsLikeData(isCelsius).value;
              final feelsLikeAsset = weather.getFeelsLikeData(isCelsius).asset;
              final humidityValue = weather.getHumidityData().value;
              final humidityAsset = weather.getHumidityData().asset;
              final rainSnowChanceValue = weather.getRainSnowChanceData().value;
              final rainSnowChanceAsset = weather.getRainSnowChanceData().asset;
              final rainSnowChanceTitle = weather.getRainSnowChanceData().more;
              final windSpeedValue = weather.getWindSpeedData().value;
              final windSpeedAsset = weather.getWindSpeedData().asset;
              final windDirectionValue = weather.getWindDirectionData().value;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDetailsItem(
                            asset: '$feelsLikeAsset',
                            title: 'Feels Like',
                            value: '${feelsLikeValue}°',
                            isLightMode: widget.isLightMode,
                          ),
                          CustomDetailsItem(
                            asset: '$humidityAsset',
                            title: 'Humidity',
                            value: '${humidityValue}%',
                            isLightMode: widget.isLightMode,
                          ),
                        ]),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDetailsItem(
                            asset: '$rainSnowChanceAsset',
                            title: '$rainSnowChanceTitle',
                            value: '${rainSnowChanceValue}%',
                            isLightMode: widget.isLightMode,
                          ),
                          CustomDetailsItem(
                            asset: '$windSpeedAsset',
                            title: 'Wind \"$windDirectionValue\"',
                            value: '${windSpeedValue}Kps',
                            isLightMode: widget.isLightMode,
                          ),
                        ]),
                  ),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}