import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mncf_weather/models/forecast_weather_response.dart';
import 'package:mncf_weather/models/settings.dart';
import 'package:mncf_weather/screens/settings_screen.dart';
import 'package:mncf_weather/services/settings_data_service.dart';
import 'package:mncf_weather/services/weather_forecast_api_service.dart';
import 'package:mncf_weather/services/location_api_service.dart';
import 'package:mncf_weather/widgets/home_screen/custom_route.dart';
import 'package:mncf_weather/widgets/home_screen/custom_display_selector.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

import '../models/location.dart';
import '../services/location_data_service.dart';
import '../utils/page_navigation_utils.dart';
import '../utils/screen_navigation_utils.dart';
import '../widgets/home_screen/custom_weather_content.dart';
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

class _HomeScreenState extends State<HomeScreen>
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
  final int sensitivity = 15;

  static const spinkit = SpinKitChasingDots(
    color: Color(0xFFEF3B08),
    size: 40.0,
  );

  late Realm locationRealm;
  late Realm settingsRealm;
  late LocationDataService locationDataService;
  late String coordinate = '';
  late bool isCelsius = true;
  late int isDay = 1;
  late bool isDayAtCurrentLocation = true;
  late int code = 113;
  late String locationName = "";
  late ForecastWeatherResponse? forecastWeatherData;
  late Future<ForecastWeatherResponse>? _forecastFuture;
  late Stream<RealmResultsChanges<Location>> locationStream;
  late Stream<RealmResultsChanges<Settings>> settingsStream;

  String _fcmToken = '';

  void getMyDeviceToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
        String? token = await messaging.getToken();
        print('Token: $token');
        setState(() {
          _fcmToken = token ?? '';
        });
      } else {
        print('User declined or has not accepted permission');
      }
    }catch (e) {
      print('getMyDeviceToken error: $e');
    }
  }

  @override
  void initState() {
    print('initState [실행]');
    super.initState();
    getMyDeviceToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Got a message whilst in the foreground!");
      print("Message data: ${message.data}");
      if(message.notification != null) {
        print("Message also contained a notification: ${message.notification!.body}");
      }
    });

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
          return spinkit;
        }
        if (locationSnapshot.hasError) {
          return Text('>>> locationSnapshot Error: ${locationSnapshot.error}');
        }
        print('>>>>> isDay in builder [$isDay]');
        Color backgroundColor = CustomWeatherScreen(isDay)
            .getCustomWeatherBackgroundColor(code: code);
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
            navigateToSettingsScreen(
              context: context,
              isLightMode: isDay == 1 ? true : false,
            );
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
              return spinkit;
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              ForecastWeatherResponse forecastWeather = snapshot.data!;
              isDay = forecastWeather.current.isDay;
              code = forecastWeather.current.condition.code;
              return _buildContent(context, forecastWeather, location!);
            } else {
              return spinkit;
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context,
      ForecastWeatherResponse weatherData, Location location) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Stack(
        children: [
          buildMainWeatherContent(
            context: context,
            locationName: locationName,
            isCelsius: isCelsius,
            weatherData: weatherData,
          ),
          buildBackgroundContent(isDay: isDay, weatherData: weatherData),
          buildSubWeatherContent(
            context: context,
            weatherData: weatherData,
          )
        ],
      ),
    );
  }

  void _loadForecastWeatherData() async {
    _forecastFuture = Future.delayed(Duration(milliseconds: 400), () {
      return fetchForecastWeatherData(coordinate, 1);
    });
    // _forecastFuture = fetchForecastWeatherData(coordinate, 1);
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
    var firstLocation = locationRealm.all<Location>().firstOrNull;

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
      var dayAtCurrentLocation = await fetchForecastWeatherData(
          '${currentLocation.latitude},${currentLocation.longitude}', 1);
      setState(() {
        final locations = locationRealm.all<Location>().toList();
        pageLength = locations.length;
        location = currentLocation;
        locationName = location!.name;
        isDayAtCurrentLocation =
            dayAtCurrentLocation.current.isDay == 1 ? true : false;
        _forecastFuture = Future.delayed(Duration(milliseconds: 400), () {
          return fetchForecastWeatherData(coordinate, 1);
        });
        // _forecastFuture = fetchForecastWeatherData(coordinate, 1);
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
        createSwipeRoute(
            DetailsScreen(
              coordinate: coordinate,
              isLightMode:
                  isDay == 1 ? true : false, // DetailsScreen light mode
              // isLightMode: false,
            ),
            'up'),
      );
    }
  }

  void _updateLocationAndWeatherData(Location location) async {
    setState(() {
      location = location;
      latitude = location.latitude;
      longitude = location.longitude;
      locationName = location.name;
      coordinate = '${location.latitude},${location.longitude}';
      // _buildIndicator();
    });
    _loadForecastWeatherData();
  }

  void _handleHorizontalSwipe(DragUpdateDetails details, BuildContext context) {
    final bool isSwipeRight = details.delta.dx > sensitivity;
    final bool isSwipeLeft = details.delta.dx < -sensitivity;
    if ((isSwipeRight || isSwipeLeft) && !isDragging && !isLoading) {
      if (currentIndex == pageLength - 1 && isSwipeLeft) {
        navigateToNewScreen(
            context: context,
            isLightMode: isDayAtCurrentLocation, // AddLocationScreen light mode
            // isLightMode: false,
            isNext: true,
            postNavigation: (value) {
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
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                });
              }
            });
      } else if (currentIndex == 0 && isSwipeRight) {
        print('IntroduceScreen');
        navigateToNewScreen(
          context: context,
          isLightMode: isDay == 1 ? true : false,
          // isLightMode: false,
          isNext: false,
          postNavigation: (value) => () {},
        );
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
                dotHeight: 6,
                dotWidth: 6,
                verticalOffset: 10,
                jumpScale: 3,
                dotColor: isDay == 1 ? Color(0xFFE9DEDA) : Color(0xFF57585E),
                activeDotColor: Color(0xFFEF3B08),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
