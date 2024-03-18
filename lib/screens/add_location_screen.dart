import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mncf_weather/models/weather.dart' as current;
import 'package:mncf_weather/screens/settings_screen.dart';
import 'package:mncf_weather/services/weather_current_api_service.dart';
import 'package:mncf_weather/utils/common_utils.dart';
import 'package:mncf_weather/utils/weather_utils.dart';
import 'package:mncf_weather/widgets/add_location_screen/city_weather_tile.dart';
import 'package:mncf_weather/widgets/add_location_screen/search_location_input.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  static const spinkit = SpinKitChasingDots(
    color: Color(0xFFEF3B08),
    size: 26.0,
  );

  late int locationCount;
  late String currentLocation;
  late String? city;
  late Realm realm;
  late var locations;
  late Color backgroundColor = Color(0xFFFFF9F6);
  late Color boxBackgroundColor = Color(0xFFFFFFFF);
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
      boxBackgroundColor =
          widget.isLightMode ? Color(0xFFFFFFFF) : Color(0xFF343438);
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
                    columnSpace(3.0),
                    Text(
                      'Regional settings',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 0.9),
                      textAlign: TextAlign.center,
                    ),
                    columnSpace(5.0),
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
                    columnSpace(5.0),
                    SearchLocationInput(
                      textController: textController,
                      config: config,
                      locationCount: locationCount,
                      backgroundColor: textFieldColor,
                      textColor: textColor,
                      textFieldColor: textFieldColor,
                      isLightMode: widget.isLightMode,
                    ),
                    columnSpace(4.0),
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
                                                isUtc: true);
                                    var monthAndDay = getWeekdates(date).first;
                                    var weekday =
                                        getWeekdays(date, false).first;
                                    var minSeconds = getMinSeconds(date).first;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 7.0,
                                      ),
                                      child: DeferredPointerHandler(
                                        child: Container(
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              CityWeatherTile(
                                                index: index,
                                                boxBackgroundColor:
                                                    boxBackgroundColor,
                                                textColor: textColor,
                                                textFieldColor: textFieldColor,
                                                city: location.name,
                                                skyCondition: conditions.first,
                                                summary:
                                                    '$monthAndDay($weekday) $minSeconds',
                                                temperature: '$temperature°',
                                                buttonBackgroundColor:
                                                    buttonBackgroundColor,
                                              ),
                                              Positioned(
                                                right: -11,
                                                top: 0,
                                                bottom: 0,
                                                child: GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      if (index != 0) {
                                                        setState(() {
                                                          final locationDataService =
                                                              LocationDataService(
                                                                  realm);
                                                          locationDataService
                                                              .removeLocationById(
                                                                  locations[
                                                                          index]
                                                                      .id);
                                                          locationCount--;
                                                          locations
                                                              .removeAt(index);
                                                        });
                                                      }
                                                    },
                                                    child: index != 0
                                                        ? Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                        40,
                                                                    maxHeight:
                                                                        40),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    backgroundColor),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 50),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Icon(
                                                              Icons
                                                                  .remove_circle_rounded,
                                                              size: 35.0,
                                                              color: Color(
                                                                  0xFFEF3B08),
                                                            ),
                                                          )
                                                        : SizedBox.shrink()),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          )
                        : spinkit
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
