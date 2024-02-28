import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/models/settings.dart';
import 'package:morning_weather/screens/settings_screen.dart';
import 'package:morning_weather/services/settings_data_service.dart';
import 'package:morning_weather/services/weather_forecast_api_service.dart';
import 'package:morning_weather/services/location_api_service.dart';
import 'package:morning_weather/widgets/home_screen/custom_day_thunder.dart';
import 'package:morning_weather/widgets/home_screen/custom_night_drizzle.dart';
import 'package:morning_weather/widgets/home_screen/custom_night_thunder.dart';
import 'package:morning_weather/widgets/home_screen/custom_route.dart';
import 'package:morning_weather/widgets/home_screen/custom_weather_screen.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/location.dart';
import '../services/location_data_service.dart';
import '../utils/page_navigation_utils.dart';
import '../utils/screen_navigation_utils.dart';
import '../widgets/home_screen/custom_weather_content.dart';
import 'details_screen.dart';

class HomeScreenV2 extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const HomeScreenV2({
    super.key,
    required this.initialLatitude,
    required this.initialLongitude,
  });

  @override
  State<HomeScreenV2> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends State<HomeScreenV2>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Location? location;
  var isLoading = false;
  var isDragging = false;
  var isDetailScreen = false;
  var latitude = '0.0';
  var longitude = '0.0';
  var currentIndex = 0;
  var pageLength = 0;
  var weatherCondition = "";
  var isLastPage = false;
  var hasSettingsInit = true;

  var pageController = PageController(viewportFraction: 1.0, keepPage: true);
  final locationConfig = Configuration.local([Location.schema]);
  final settingsConfig = Configuration.local([Settings.schema]);
  final int sensitivity = 20;

  late Realm locationRealm;
  late Realm settingsRealm;
  late LocationDataService locationDataService;
  late String coordinate = '';
  late bool isCelsius;
  late int isDay = 1;
  late int code = 113;
  late ForecastWeatherResponse? forecastWeatherData;
  late Future<ForecastWeatherResponse>? _forecastFuture;
  late Stream<RealmResultsChanges<Location>> locationStream;
  late Stream<RealmResultsChanges<Settings>> settingsStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitLocationData();
    _loadInitSettingsData();
  }

  @override
  void dispose() {
    locationRealm.close();
    settingsRealm.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (currentIndex == 0) {
        location = locationRealm.all<Location>().first;
      }
      _loadForecastWeatherData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!hasSettingsInit == true) {
      final settingsProvider = Provider.of<SettingsProvider>(context);
      isCelsius = settingsProvider.isCelsius;
    }

    return StreamBuilder<RealmResultsChanges<Location>>(
      stream: locationStream,
      builder: (context, locationSnapshot) {
        if (locationSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (locationSnapshot.hasError) {
          return Text('>>> locationSnapshot Error: ${locationSnapshot.error}');
        }
        print('>>>>> isDay in builder [$isDay]');
        Color backgroundColor =
            CustomWeatherScreen(isDay).getCustomWeatherBackgroundColor(code: code);
        return Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: backgroundColor,
          body: StreamBuilder<RealmResultsChanges<Settings>>(
              stream: settingsStream,
              builder: (context, snapshot) {
                return PageView.builder(
                  controller: pageController,
                  itemCount: pageLength,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) => _buildBody(context),
                );
              }),
          bottomNavigationBar: _buildIndicator(),
        );
      },
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      print('>>>> _onPageChanged [실행]');
      currentIndex = index;
    });

    final newLocation = locationRealm.all<Location>().elementAt(index);
    _updateLocationAndWeatherData(newLocation);
    isLastPage = false;

    if (index >= pageLength - 1) {
      isLastPage = true;
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: isDay == 1 ? Brightness.light : Brightness.dark,
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              hasSettingsInit = false;
            });
            navigateToSettingsScreen(context);
          },
          icon: Icon(
            Icons.settings_outlined,
            color: Color(0xFF909090),
          ),
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
              // _refreshIsDay(forecastWeather);
                isDay = forecastWeather.current.isDay;
                code = forecastWeather.current.condition.code;
              return _buildContent(context, forecastWeather, location!);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context,
      ForecastWeatherResponse weatherData, Location location) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          buildMainWeatherContent(
            isCelsius: isCelsius,
            weatherData: weatherData,
          ),
          buildBackgroundContent(isDay: isDay, weatherData: weatherData),
          // isDay == 1 ? CustomDayThunder() : CustomNightThunder(),
          buildSubWeatherContent(
            context: context,
            weatherData: weatherData,
          )
        ],
      ),
    );
  }

  void _loadForecastWeatherData() async {
    _forecastFuture = fetchForecastWeatherData(coordinate, 1);
    final newWeatherData = await fetchForecastWeatherData(coordinate, 1);
    setState(() {
      print('>>>>> isDay [$isDay]');
      forecastWeatherData = newWeatherData;
      isDay = newWeatherData.current.isDay;
      print('>>>>> isDay [$isDay]');
      code = newWeatherData.current.condition.code;
    });
  }

  void _loadInitLocationData() async {
    locationRealm = Realm(locationConfig);
    locationStream = locationRealm.all<Location>().changes;
    locationDataService = LocationDataService(locationRealm);
    final firstLocation = locationRealm.all<Location>().firstOrNull;

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
        final locations = locationRealm.all<Location>().toList();
        pageLength = locations.length;
        location = currentLocation;
        _forecastFuture = fetchForecastWeatherData(coordinate, 1);
      });
    });
  }

  void _loadInitSettingsData() async {
    settingsRealm = Realm(settingsConfig);
    settingsStream = settingsRealm.all<Settings>().changes;
    final settingsData = SettingsDataService(settingsRealm);
    final settings = await settingsData.fetchSettings();
    if (settings != null) {
      isCelsius = settings.isCelsius;
      print('_loadInitSettingsData isCelsius [$isCelsius]');
    } else {
      isCelsius = false;
    }
    hasSettingsInit = true;
  }

  void _handleVerticalSwipe(DragUpdateDetails details, BuildContext context) {
    if (details.delta.dy < -sensitivity) {
      Navigator.of(context).push(
        createSwipeRoute(DetailsScreen(coordinate: coordinate), 'up'),
      );
    }
  }

  void _updateLocationAndWeatherData(Location location) async {
    setState(() {
      location = location;
      latitude = location.latitude;
      longitude = location.longitude;
      coordinate = '${location.latitude},${location.longitude}';
    });
    _loadForecastWeatherData();
  }

  void _handleHorizontalSwipe(DragUpdateDetails details, BuildContext context) {
    final bool isSwipeRight = details.delta.dx > sensitivity;
    final bool isSwipeLeft = details.delta.dx < -sensitivity;
    if ((isSwipeRight || isSwipeLeft) && !isDragging && !isLoading) {
      if (currentIndex == pageLength - 1 && isSwipeLeft) {
        navigateToNewScreen(context, true, (value) {
          if (value) {
            final newConfig = Configuration.local([Location.schema]);
            final newRealm = Realm(newConfig);
            final newLocationData = LocationDataService(newRealm);
            final newLocations = newLocationData.fetchLocations();
            setState(() {
              _updateLocationAndWeatherData(newLocations.last);
              pageLength = newLocations.length;
              currentIndex = pageLength - 1;
              pageController.animateToPage(
                currentIndex,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            });
          }
        });
      } else if (currentIndex == 0 && isSwipeRight) {
        // Todo Navigate To IntroduceScreen
        print('IntroduceScreen');
        navigateToNewScreen(context, false, (value) => () {});
      } else {
        navigateToPage(pageController, pageLength, isSwipeLeft);
      }
      isDragging = true;
      isLoading = true;
    }
  }

  Widget _buildIndicator() {
    return pageLength > 0
        ? Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height * 0.07,
            child: SmoothPageIndicator(
              controller: pageController,
              count: pageLength,
              effect: JumpingDotEffect(
                  dotHeight: 6, dotWidth: 6, verticalOffset: 10, jumpScale: 3),
            ),
          )
        : SizedBox.shrink();
  }
}
