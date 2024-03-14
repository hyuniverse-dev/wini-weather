import 'package:flutter/material.dart';
import 'package:mncf_weather/models/weather.dart' as current;
import 'package:mncf_weather/screens/settings_screen.dart';
import 'package:mncf_weather/services/weather_current_api_service.dart';
import 'package:mncf_weather/utils/common_utils.dart';
import 'package:mncf_weather/utils/weather_utils.dart';
import 'package:mncf_weather/widgets/add_location_screen/city_weather_tile.dart';
import 'package:mncf_weather/widgets/add_location_screen/search_location_input.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import '../models/location.dart';
import '../services/location_data_service.dart';
import '../utils/date_utils.dart';

class AddLocationScreen extends StatefulWidget {
  final bool isLightMode;

  const AddLocationScreen({super.key, required this.isLightMode});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  var dragDistance = 0.0;
  var config = Configuration.local([Location.schema]);

  final TextEditingController textController = TextEditingController();
  final double minDragDistance = 0;
  final double minVelocity = 0;
  late int locationCount;
  late String currentLocation;
  late String? city;
  late Realm realm;
  late var locations;
  late Color backgroundColor = Color(0xFFFFF9F6);
  late Color textColor = Color(0xFF1D1F21);
  late Color textFieldColor = Color(0xFF1D1F21);
  late Color buttonBackgroundColor = Color(0xFF1D1F21);

  @override
  void initState() {
    super.initState();
    realm = Realm(config);
    setState(() {
      final locationDataService = LocationDataService(realm);
      locations = locationDataService.fetchLocations();
      currentLocation = locations[0].city;
      locationCount = locations.length;
      backgroundColor =
          widget.isLightMode ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
      textColor = widget.isLightMode ? Color(0xFF1D1F21) : Color(0xFFFFF9F6);
      textFieldColor =
          widget.isLightMode ? Colors.transparent : Color(0xFF343438);
      buttonBackgroundColor =
          widget.isLightMode ? Color(0xFFFFF9F6) : Color(0xFF1D1F21);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                  children: <Widget>[
                    Text(
                      'Regional settings',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 0.9),
                      textAlign: TextAlign.center,
                    ),
                    columnSpace(1.0),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            'assets/images/backgrounds/add_location_background2.png',
                            width: 52.0,
                            height: 55.0,
                          ),
                        ),
                        Image.asset(
                          'assets/images/backgrounds/add_location_background1.png',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SearchLocationInput(
                      textController: textController,
                      config: config,
                      locationCount: locationCount,
                      backgroundColor: textFieldColor,
                      textColor: textColor,
                      textFieldColor: textFieldColor,
                      isLightMode: widget.isLightMode,
                    ),
                    SizedBox(
                      height: 40,
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
                                    final settingsProvider =
                                        Provider.of<SettingsProvider>(context);
                                    final current = snapshot.data!.current;
                                    var temperature = settingsProvider.isCelsius
                                        ? current.tempC.round()
                                        : current.tempF.round();
                                    var windKph = current.windKph.toString();
                                    List<String> conditions = [];
                                    divisionWeatherCodeToText(
                                        current.condition.code, conditions);
                                    var date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                                snapshot.data!.location
                                                        .localtimeEpoch *
                                                    1000,
                                                isUtc: true)
                                            .toLocal();
                                    var monthAndDay = getWeekdates(date).first;
                                    var weekday =
                                        getWeekdays(date, false).first;
                                    var minSeconds = getMinSeconds(date).first;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 7.0,
                                      ),
                                      child: CityWeatherTile(
                                        index: index,
                                        backgroundColor: backgroundColor,
                                        textColor: textColor,
                                        textFieldColor: textFieldColor,
                                        city: location.name,
                                        skyCondition: conditions.first,
                                        summary:
                                            '$monthAndDay($weekday) $minSeconds',
                                        temperature: '$temperature°',
                                        buttonBackgroundColor:
                                            buttonBackgroundColor,
                                        onRemovePressed: () {
                                          setState(() {
                                            final locationDataService =
                                                LocationDataService(realm);
                                            locationDataService
                                                .removeLocationById(
                                                    location.id);
                                            locationCount--;
                                          });
                                          locations.removeAt(index);
                                        },
                                      ),
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
