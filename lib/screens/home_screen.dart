import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/screens/add_location_screen.dart';
import 'package:morning_weather/screens/introduce_screen.dart';
import 'package:morning_weather/screens/settings_screen.dart';
import 'package:morning_weather/services/forecast_weather_service.dart';
import 'package:morning_weather/utils/route_utils.dart';
import 'package:realm/realm.dart' hide ConnectionState;

import '../models/location.dart';
import '../widgets/home_screen/cards.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = true;
  var isDragging = false;
  var isDetailScreen = false;
  var location;
  var latitude = '0.0';
  var longitude = '0.0';
  var currentIndex = 0;
  final config = Configuration.local([Location.schema]);

  final int sensitivity = 20;
  Realm? realm;

  // var currentId;
  String coodinate = '';
  ForecastWeatherResponse? forecastWeatherData;
  Future<ForecastWeatherResponse>? _forecastFuture;

  @override
  void initState() {
    super.initState();
    print('initState Called');
    realm = Realm(config);
    location = realm!.all<Location>().firstOrNull;

    // Todo Refactoring soon..
    if (location == null) {
      realm!.write(() {
        realm!.add(Location(
          getLastPrimaryKey(realm!),
          'Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright',
          '35.1799528',
          '129.0752365',
          'busan',
          '부산광역시',
          '대한민국',
        ));
      });
    }

    latitude = location.latitude ?? '35.1799528';
    longitude = location.longitude ?? '129.0752365';
    coodinate = '$latitude,$longitude';
    _forecastFuture = fetchForecastWeatherData(coodinate, 1);
  }

  void _loadForecastWeatherData() {
    _forecastFuture = fetchForecastWeatherData(coodinate, 1);
  }

  void _handleVerticalSwipe(DragUpdateDetails details, BuildContext context) {
    if (details.delta.dy < -sensitivity) {
      Navigator.of(context).push(
        createSwipeRoute(DetailsScreen(coodinate: coodinate), 'up'),
      );
    }
  }

  bool _tryFetchFirstLocationId() {
    final firstLocation = realm!.all<Location>().firstOrNull;
    return !(firstLocation!.id == location.id);
  }

  bool _tryUpdateToNextLocation() {
    final List<Location> locations = realm!.all<Location>().toList();
    currentIndex = locations.indexWhere((loc) => loc.id == location.id);
    Location currentLocation = locations[currentIndex];
    print('beforeLocation.id >>> ${currentLocation.id}');
    print('beforeLocation.name >>> ${currentLocation.name}');

    if (currentIndex != -1 && currentIndex < locations.length - 1) {
      var nextLocation = locations[currentIndex + 1];
      if (location.id != nextLocation.id) {
        _updateLocationAndWeatherData(nextLocation);
        print('updatedLocation.id >>> ${nextLocation.id}');
        print('updatedLocation.name >>> ${nextLocation.name}');
        return true;
      }
    }
    return false;
  }

  bool _tryUpdateToBeforeLocation() {
    final List<Location> locations = realm!.all<Location>().toList();
    int currentIndex = locations.indexWhere((loc) => loc.id == location.id);
    Location currentLocation = locations[currentIndex];
    print('beforeLocation.id >>> ${currentLocation.id}');
    print('beforeLocation.name >>> ${currentLocation.name}');

    if (currentIndex != -1 && currentIndex > 0) {
      var beforeLocation = locations[currentIndex - 1];
      print('updatedLocation.id >>> ${beforeLocation.id}');
      print('updatedLocation.name >>> ${beforeLocation.name}');
      if (location.id != beforeLocation.id) {
        _updateLocationAndWeatherData(beforeLocation);
        return true;
      }
    }
    return false;
  }

  void _updateLocationAndWeatherData(Location newLocation) {
    setState(() {
      location = newLocation;
      latitude = newLocation.latitude;
      longitude = newLocation.longitude;
      coodinate = '${newLocation.latitude},${newLocation.longitude}';
      _loadForecastWeatherData();
    });
  }

  void _handleHorizontalSwipe(DragUpdateDetails details, BuildContext context) {
    if (details.delta.dx > sensitivity && !isDragging) {
      var hasBeforeLocation = _tryUpdateToBeforeLocation();
      isDragging = true;
      if (!hasBeforeLocation) {
        Navigator.of(context)
            .push(
              createSwipeRoute(IntroduceScreen(), 'left'),
            )
            .then((_) => isDragging = false);
        print('hasBeforeLocation is False');
      }
    } else if (details.delta.dx < -sensitivity && !isDragging) {
      var hasNextLocation = _tryUpdateToNextLocation();
      isDragging = true;
      if (!hasNextLocation) {
        Navigator.of(context)
            .push(
          createSwipeRoute(AddLocationScreen(), 'right'),
        )
            .then((value) {
          if (value) {
            setState(() {
              final config = Configuration.local([Location.schema]);
              Realm realm = Realm(config);
              location = realm!.all<Location>().lastOrNull;
              _updateLocationAndWeatherData(location);
            });
          }
        });
      }
    }
  }

  void removeLocationData(int id) {
    final config = Configuration.local([Location.schema]);
    var realm = Realm(config);

    final List<Location> locations = realm.all<Location>().toList();
    int currentIndex = locations.indexWhere((loc) => loc.id == location.id);

    realm.write(() {
      var locationToRemove = realm.query<Location>('id == $id').firstOrNull;
      print('locationToRemove >>> ${locationToRemove!.id}');
      print('locationToRemove >>> ${locationToRemove!.name}');
      if (locationToRemove != null) {
        realm.delete(locationToRemove);
      }
    });
    setState(() {
      location = locations[currentIndex - 1];
    });
    _updateLocationAndWeatherData(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => _navigateToSettings(context),
          icon: Icon(Icons.settings),
        ),
        _tryFetchFirstLocationId()
            ? IconButton(
                onPressed: () => removeLocationData(location.id),
                icon: Icon(Icons.delete),
              )
            : SizedBox.shrink()
      ],
    );
  }

  void _navigateToSettings(BuildContext context) {
    print('SettingsScreen Button Click!');
    Navigator.of(context).push(
      createOntapRoute(SettingsScreen(), 'settingsScreen'),
    );
  }

  Widget _buildBody(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        _handleVerticalSwipe(details, context);
        if (details.delta.dy < -sensitivity) {
          isDetailScreen = true;
        }
      },
      onHorizontalDragUpdate: (details) {
        _handleHorizontalSwipe(details, context);
      },
      onHorizontalDragEnd: (details) {
        isDragging = false;
      },
      child: Center(
        child: FutureBuilder<ForecastWeatherResponse>(
          future: _forecastFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return isDetailScreen ? SizedBox() : CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              ForecastWeatherResponse forecastWeather = snapshot.data!;
              return _buildContent(context, forecastWeather);
            } else {
              return Text('No Data');
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, ForecastWeatherResponse forecastWeatherData) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final String country = forecastWeatherData.location.country;
    final String location = forecastWeatherData.location.name;
    final double feelsTemp = forecastWeatherData.current.feelsC;
    final double currentTemp = forecastWeatherData.current.tempC;
    final double hTemp =
        forecastWeatherData.forecast.forecastDay[0].day.maxTempC;
    final double lTemp =
        forecastWeatherData.forecast.forecastDay[0].day.minTempC;

    return Stack(
      alignment: Alignment.center,
      children: [
        _buildBackgroundContainer(),
        buildMainCard(screenWidth, screenHeight, country, location, feelsTemp,
            currentTemp, hTemp, lTemp),
        Positioned(
          right: MediaQuery.of(context).size.width * 0.03,
          top: MediaQuery.of(context).size.height * 0.1,
          width: screenWidth * 0.7,
          height: screenHeight * 0.35,
          child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: buildWiniCard()),
        ),
      ],
    );
  }

  Widget _buildBackgroundContainer() {
    return Positioned.fill(
      child: Container(
        color: Colors.white,
      ),
    );
  }
}
