import 'package:flutter/material.dart';
import 'package:mncf_weather/models/weather.dart' as current;
import 'package:mncf_weather/services/weather_current_api_service.dart';
import 'package:mncf_weather/widgets/add_location_screen/city_weather_tile.dart';
import 'package:mncf_weather/widgets/add_location_screen/search_location_input.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import '../models/location.dart';
import '../services/location_data_service.dart';
import '../utils/date_utils.dart';

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
      final locationDataService = LocationDataService(realm);
      locations = locationDataService.fetchLocations();
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
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    SearchLocationInput(
                      textController: textController,
                      config: config,
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
                                future: fetchWeatherData(
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
                                    var tempC = snapshot.data!.current.tempC;
                                    var windKph = snapshot.data!.current.windKph
                                        .toString();
                                    var date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            snapshot.data!.location
                                                    .localtimeEpoch *
                                                1000,
                                            isUtc: true);
                                    var weekday = getWeekdays(date);
                                    return CityWeatherTile(
                                      index: index,
                                      city: location.name,
                                      weatherIcon: Icons.sunny,
                                      summary:
                                          '${weekday[0]}, ${tempC}°C, ${windKph}kph',
                                      onRemovePressed: () {
                                        setState(() {
                                          final locationDataService =
                                              LocationDataService(realm);
                                          locationDataService
                                              .removeLocationById(location.id);
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
