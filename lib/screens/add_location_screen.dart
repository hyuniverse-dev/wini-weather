import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:morning_weather/models/weather.dart' as current;
import 'package:morning_weather/services/location_service.dart';
import 'package:morning_weather/services/weather_service.dart';
import 'package:morning_weather/utils/alert_utils.dart';
import 'package:morning_weather/utils/calculate_utils.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import '../models/location.dart';
import '../utils/api_utils.dart';
import '../utils/realm_utils.dart';

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  var dragDistance = 0.0;
  var config = Configuration.local([Location.schema]);

  final TextEditingController textController = TextEditingController();
  final double minDragDistance = 0;
  final double minVelocity = 0;
  late String currentLocation;
  late String? city;
  late Realm realm;
  late var locations;

  @override
  void initState() {
    super.initState();
    realm = Realm(config);
    setState(() {
      locations = fetchLocations(realm);
      currentLocation = locations[0].city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          dragDistance += details.delta.dx;
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          if (dragDistance > minDragDistance &&
              details.velocity.pixelsPerSecond.dx > minVelocity) {
            Navigator.of(context).pop(true);
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Text(
                      'Search\nLocation',
                      style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                          height: 0.9),
                      textAlign: TextAlign.center,
                    ),
                    Image.asset(
                      'assets/images/search_location.png',
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.black45),
                          children: [
                            TextSpan(text: 'Current Location : '),
                            TextSpan(
                                text: '${currentLocation}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                          ],
                        ),
                      ),
                    ),
                    TextField(
                      controller: textController,
                      decoration: InputDecoration(
                        labelText: 'Search the weather by area',
                        labelStyle:
                            TextStyle(color: Colors.black, fontSize: 12),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.keyboard_return_rounded),
                          onPressed: () async {
                            final inputValue = textController.text;
                            if (inputValue.isEmpty) {
                              showValidateDialog(context, inputValue);
                            } else {
                              final locationData =
                                  await fetchLocationData(inputValue);
                              if (locationData != null) {
                                var extractData =
                                    await extractLocationData(locationData);
                                if (extractData != null) {
                                  city = extractData['city'] ?? 'Unknown City';
                                  final isOk =
                                      await showConfirmDialog(context, city!);
                                  if (isOk == true) {
                                    // Create Local Database
                                    realm = Realm(config);
                                    realm.write(() {
                                      realm.add(
                                        Location(
                                          getLastPrimaryKey(realm),
                                          locationData.licence,
                                          locationData.latitude,
                                          locationData.longitude,
                                          locationData
                                                  .nameDetails.officialNameEn ??
                                              locationData.address.city!,
                                          locationData.address.city ??
                                              locationData.name,
                                          locationData.address.country,
                                        ),
                                      );
                                    });
                                    Navigator.pop(context, true);
                                    textController.clear();
                                  } else if (isOk == false) {
                                    textController.clear();
                                  }
                                } else {
                                  print('No data extracted.');
                                }
                              } else {
                                print('Location data not found');
                              }
                            }
                          },
                        ),
                      ),
                      onSubmitted: (String value) {
                        print(textController.text);
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'How\'s the weather in this place?',
                        style: TextStyle(
                            color: Colors.black45, fontWeight: FontWeight.bold),
                      ),
                    ),
                    locations.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: locations.length,
                            itemBuilder: (context, index) {
                              var location = locations[index];
                              return FutureBuilder<current.WeatherResponse>(
                                future: _fetchCurrentWeather(
                                    '${location.latitude},${location.longitude}'),
                                builder: (BuildContext context,
                                    AsyncSnapshot<current.WeatherResponse>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return SizedBox();
                                  } else if (snapshot.hasError) {
                                    return Text('Error : ${snapshot.error}');
                                  } else {
                                    var tempC =
                                        snapshot.data!.current.tempC.toString();
                                    var windKph = snapshot.data!.current.windKph
                                        .toString();
                                    var date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            snapshot.data!.location
                                                    .localtimeEpoch *
                                                1000,
                                            isUtc: true);
                                    var weekday = getCurrentWeekday(date);

                                    return LocationWeatherItem(
                                      index: index,
                                      city: location.name,
                                      weatherIcon: Icons.sunny,
                                      summary:
                                          '${weekday[0]}, ${tempC}°C, ${windKph}kph',
                                      onRemovePressed: () {
                                        setState(() {
                                          removeLocationById(
                                              realm, location.id);
                                        });
                                        locations.removeAt(index);
                                      },
                                    );
                                  }
                                },
                              );
                            },
                          )
                        : RefreshProgressIndicator()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // ),
    );
  }
}

Future<current.WeatherResponse> _fetchCurrentWeather(String coordinate) async {
  try {
    var currentWeather = await fetchWeatherData(coordinate);
    return currentWeather;
  } catch (e) {
    return throw Exception('_fetchCurrentWeather Error : $e');
  }
}

class LocationWeatherItem extends StatelessWidget {
  final int index;
  final String city;
  final IconData weatherIcon;
  final String summary;
  final VoidCallback onRemovePressed;

  const LocationWeatherItem({
    super.key,
    required this.index,
    required this.city,
    required this.weatherIcon,
    required this.summary,
    required this.onRemovePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black12,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                weatherIcon,
                size: 46,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.length > 10 ? '${city.substring(0, 10)}...' : city,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(summary),
                ],
              ),
              Spacer(),
              index == 0
                  ? Icon(
                      Icons.block,
                      color: Colors.white.withOpacity(1.0),
                    )
                  : IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        size: 26.0,
                        color: Colors.black45,
                      ),
                      onPressed: onRemovePressed,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
