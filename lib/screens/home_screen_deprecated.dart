import 'package:flutter/material.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/services/weather_forecast_api_service.dart';
import 'package:morning_weather/services/location_api_service.dart';
import 'package:morning_weather/widgets/home_screen/custom_route.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/location.dart';
import '../services/location_data_service.dart';
import '../utils/page_navigation_utils.dart';
import '../utils/screen_navigation_utils.dart';
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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  var isLoading = false;
  var isDragging = false;
  var isDetailScreen = false;

  var latitude = '0.0';
  var longitude = '0.0';
  var currentIndex = 0;
  var pageIndex = 0;
  var pageLength = 0;
  final config = Configuration.local([Location.schema]);
  final pageController = PageController(viewportFraction: 1.0, keepPage: true);
  final int sensitivity = 20;
  Location? location;
  late Realm realm;
  late LocationDataService locationDataService;
  late String coordinate = '';
  late ForecastWeatherResponse? forecastWeatherData;
  late Future<ForecastWeatherResponse>? _forecastFuture;
  late final Stream<RealmResultsChanges<Location>> stream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    realm = Realm(config);
    stream = realm!.all<Location>().changes;
    locationDataService = LocationDataService(realm);
    final firstLocation = realm?.all<Location>().firstOrNull;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      coordinate =
          '${widget.initialLatitude.toStringAsFixed(7)},${widget.initialLongitude.toStringAsFixed(7)}';
      print(coordinate);
      final initialLocation = await fetchLocationData(coordinate);
      final currentLocation = Location(
        1,
        initialLocation.licence,
        initialLocation.latitude.substring(0, 7),
        initialLocation.longitude.substring(0, 7),
        initialLocation.nameDetails.officialNameEn ??
            initialLocation.address.city!,
        initialLocation.address.city ?? initialLocation.name,
        initialLocation.address.country,
      );

      if (firstLocation == null) {
        locationDataService.createLocation(currentLocation);
      } else {
        locationDataService.updateLocation(currentLocation);
      }
      setState(() {
        final locations = realm!.all<Location>().toList();
        pageLength = locations.length;
        location = currentLocation;
        _forecastFuture = fetchForecastWeatherData(coordinate, 1);
      });
    });
  }

  @override
  void dispose() {
    realm?.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('didChangeAppLifecycleState 실행 >>> ');
      print('current index >>> $currentIndex');
      print('page index >>> $pageIndex');
      if (pageIndex == 0) {
        location = realm!.all<Location>().first;
      }
      _loadForecastWeatherData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RealmResultsChanges<Location>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return RefreshProgressIndicator();
        return Scaffold(
          appBar: _buildAppBar(context),
          body: location == null
              ? Center(
                  child: RefreshProgressIndicator(),
                )
              : Column(
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
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => navigateToSettingsScreen(context),
          icon: Icon(Icons.settings),
        ),
      ],
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
        isLoading = false;
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
              return _buildContent(context, forecastWeather, location!);
            } else {
              return Text('Loading...');
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context,
      ForecastWeatherResponse forecastWeatherData, Location location) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final String country = location.country;
    final String name = location.name;
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
              // child: buildWiniCard(),
          ),
        ),
      ],
    );
  }

  void _loadForecastWeatherData() {
    _forecastFuture = fetchForecastWeatherData(coordinate, 1);
  }

  void _handleVerticalSwipe(DragUpdateDetails details, BuildContext context) {
    if (details.delta.dy < -sensitivity) {
      Navigator.of(context).push(
        createSwipeRoute(DetailsScreen(coordinate: coordinate), 'up'),
      );
    }
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
    final bool isSwipeRight = details.delta.dx > sensitivity;
    final bool isSwipeLeft = details.delta.dx < -sensitivity;

    if ((isSwipeRight || isSwipeLeft) && !isDragging && !isLoading) {
      if (isSwipeLeft) {
        pageIndex++;
        print(pageIndex);
      } else {
        pageIndex--;
        print(pageIndex);
      }
      navigateToPage(pageController, pageLength, isSwipeLeft);
      final updatedLocation =
          locationDataService.handleLocationUpdate(isSwipeLeft, location!);
      if (updatedLocation != null) {
        _updateLocationAndWeatherData(updatedLocation);
      }

      isDragging = true;
      isLoading = true;

      if (updatedLocation == null) {
        navigateToNewScreen(context, isSwipeLeft, (value) {
          if (isSwipeLeft) {
            if (value != null && value == true) {
              setState(() {
                final config = Configuration.local([Location.schema]);
                Realm realm = Realm(config);
                final locations = realm.all<Location>();

                // pageLength Update
                pageLength = locations.length;

                // pagePoint Update to last
                if (pageController.hasClients && pageLength > 0) {
                  pageController.animateToPage(
                    pageLength - 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                }
                location = locations.lastOrNull!;
                _updateLocationAndWeatherData(location!);
              });
            }
          } else {
            isLoading = false;
            isDragging = false;
            print('BeforeLocation is null');
          }
        });
      }
    }
  }

  Widget _buildIndicator() {
    if (pageLength == null || pageLength.isNaN || pageLength <= 0) {
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
            dotHeight: 6,
            dotWidth: 6,
            verticalOffset: 16,
            jumpScale: .7,
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundContainer() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/test1.png"),
              fit: BoxFit.cover
          ),
        )
        // color: Colors.white,
      ),
    );
  }
}
