import 'package:flutter/material.dart';
import 'package:morning_weather/models/details_data.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/screens/settings_screen.dart';
import 'package:morning_weather/services/weather_forecast_api_service.dart';
import 'package:morning_weather/utils/weahter_utils.dart';
import 'package:provider/provider.dart';

import 'custom_details_item.dart';

class DetailsSection extends StatefulWidget {
  final String location;
  final int dayCount;
  static const double columnSpacing = 10.0;

  const DetailsSection({
    super.key,
    required this.location,
    required this.dayCount,
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
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            'Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(height: DetailsSection.columnSpacing),
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
                        CustomDetailsItem(asset: '$feelsLikeAsset', title: 'Feels Like', value: '$feelsLikeValue',),
                        CustomDetailsItem(asset: '$humidityAsset', title: 'Humidity', value: '$humidityValue'),
                      ]
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDetailsItem(asset: '$rainSnowChanceAsset', title: '$rainSnowChanceTitle', value: '$rainSnowChanceValue',),
                        CustomDetailsItem(asset: '$windSpeedAsset', title: 'Wind \"$windDirectionValue\"', value: '$windSpeedValue',),
                      ]
                    ),
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