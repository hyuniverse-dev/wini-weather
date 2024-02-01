import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/screens/add_location_screen.dart';
import 'package:morning_weather/screens/introduce_screen.dart';
import 'package:morning_weather/screens/settings_screen.dart';
import 'package:morning_weather/services/forecast_weather_service.dart';
import 'package:morning_weather/services/location_service.dart';
import 'package:morning_weather/services/weather_service.dart';
import 'package:morning_weather/utils/realm_utils.dart';
import 'package:morning_weather/utils/route_utils.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/location.dart';
import '../widgets/home_screen/cards.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const HomeScreen({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
  });

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
  var pageIndex = 0;
  var pageLength = 0;
  final config = Configuration.local([Location.schema]);
  final pageController = PageController(viewportFraction: 1.0, keepPage: true);
  final int sensitivity = 20;
  Realm? realm;
  String coordinate = '';
  ForecastWeatherResponse? forecastWeatherData;
  Future<ForecastWeatherResponse>? _forecastFuture;

  @override
  void initState() {
    print('initState Called');
    super.initState();
    realm = Realm(config);
    final firstLocation = realm?.all<Location>().firstOrNull;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      coordinate = '${widget.initialLatitude},${widget.initialLongitude}';
      final initialLocation = await fetchLocationData(coordinate);
      final currentLocation = Location(
        1,
        initialLocation.licence,
        initialLocation.latitude,
        initialLocation.longitude,
        initialLocation.name,
        initialLocation.address.city ?? initialLocation.name,
        initialLocation.address.country,
      );

      if (firstLocation == null) {
        createLocation(realm!, currentLocation);
      } else {
        updateLocation(realm!, currentLocation);
      }
      setState(() {
        final locations = realm!.all<Location>().toList();
        pageLength = locations.length;
        location = currentLocation;
        _forecastFuture = fetchForecastWeatherData(coordinate, 1);
      });
    });
  }

  void _loadForecastWeatherData() {
    _forecastFuture = fetchForecastWeatherData(coordinate, 1);
  }

  void _handleVerticalSwipe(DragUpdateDetails details, BuildContext context) {
    if (details.delta.dy < -sensitivity) {
      Navigator.of(context).push(
        createSwipeRoute(DetailsScreen(coodinate: coordinate), 'up'),
      );
    }
  }

  bool _tryFetchFirstLocationId() {
    final firstLocation = realm!.all<Location>().firstOrNull;
    if (firstLocation == null || location == null) {
      return false;
    }
    return firstLocation.id != location.id;
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
        // pageIndex++;
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
        // pageIndex--;
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
      coordinate = '${newLocation.latitude},${newLocation.longitude}';
      _loadForecastWeatherData();
    });
  }

  void _handleHorizontalSwipe(DragUpdateDetails details, BuildContext context) {
    if (details.delta.dx > sensitivity && !isDragging) {
      // 오른쪽으로 스와이프
      if (pageController.page!.round() > 0) {
        pageController.previousPage(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }

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
      // 왼쪽으로 스와이프
      if (pageController.page!.round() < pageLength - 1) {
        pageController.nextPage(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }

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
              final locations = realm!.all<Location>();

              // pageLength Update
              pageLength = locations.length;

              // pagePoint Update to last
              if (pageController.hasClients && pageLength > 0) {
                pageController.animateToPage(
                  pageLength - 1,
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                );
              }

              location = locations.lastOrNull;
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

    setState(() {
      realm.write(() {
        var locationToRemove = realm.query<Location>('id == $id').firstOrNull;
        print('locationToRemove >>> ${locationToRemove!.id}');
        print('locationToRemove >>> ${locationToRemove!.name}');
        if (locationToRemove != null) {
          realm.delete(locationToRemove);
        }
      });
    });

    setState(() {
      location = locations[currentIndex - 1];
      // pageLength Update
      pageLength = (locations.length - 1);
      // pagePoint Update to last
      if (pageController.hasClients && pageLength > 0) {
        pageController.animateToPage(
          currentIndex - 1,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    });
    _updateLocationAndWeatherData(location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              itemCount: pageLength,
              itemBuilder: (context, index) {
                return _buildBody(context);
              },
            ),
          ),
          _buildIndicator()
        ],
      ),
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
              return isDetailScreen ? SizedBox() : RefreshProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              ForecastWeatherResponse forecastWeather = snapshot.data!;
              return _buildContent(context, forecastWeather);
            } else {
              return Text('Loading...');
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
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: buildWiniCard()),
        ),
      ],
    );
  }

  Widget _buildIndicator() {
    if (pageLength == null ||
        pageLength.isNaN ||
        pageLength <= 0) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 30.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SmoothPageIndicator(
          controller: pageController,
          count: pageLength,
          effect: const JumpingDotEffect(
            dotHeight: 12,
            dotWidth: 12,
            verticalOffset: 20,
            jumpScale: .7,
            // type: WormType.thinUnderground,
          ),
        ),
      ),
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
