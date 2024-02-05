import 'package:flutter/material.dart';
import 'package:morning_weather/models/forecast_weather_response.dart';
import 'package:morning_weather/screens/add_location_screen.dart';
import 'package:morning_weather/screens/introduce_screen.dart';
import 'package:morning_weather/screens/settings_screen.dart';
import 'package:morning_weather/services/forecast_weather_service.dart';
import 'package:morning_weather/services/location_service.dart';
import 'package:morning_weather/utils/realm_utils.dart';
import 'package:morning_weather/widgets/home_screen/custom_route.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/location.dart';
import '../utils/geo_utils.dart';
import '../utils/navigation_utils.dart';
import '../widgets/home_screen/custom_cards.dart';
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

  var latitude = '0.0';
  var longitude = '0.0';
  var currentIndex = 0;
  var pageIndex = 0;
  var pageLength = 0;
  final config = Configuration.local([Location.schema]);
  final pageController = PageController(viewportFraction: 1.0, keepPage: true);
  final int sensitivity = 20;
  Location? location;
  late Realm? realm;
  late String coordinate = '';
  late ForecastWeatherResponse? forecastWeatherData;
  late Future<ForecastWeatherResponse>? _forecastFuture;

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

    if ((isSwipeRight || isSwipeLeft) && !isDragging) {
      navigateToPage(pageController, pageLength, isSwipeLeft);

      final updatedLocation =
          handleLocationUpdate(isSwipeLeft, realm!, location!);
      if (updatedLocation != null) {
        _updateLocationAndWeatherData(updatedLocation);
      }

      isDragging = true;

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
                    duration: Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  );
                }
                location = locations.lastOrNull!;
                _updateLocationAndWeatherData(location!);
              });
            }
          } else {
            isDragging = false;
            print('BeforeLocation is null');
          }
        });
      }
    }
  }

  void removeLocationData(int id) {
    removeLocation(id).then((result) => {
          // 비동기 작업의 결과로 받은 데이터를 사용하여 UI 상태를 업데이트합니다.
          setState(() {
            // 'locations'와 'currentIndex'는 이 컴포넌트의 상태를 나타내는 변수입니다.
            // 이들 변수의 정의와 초기화는 이 예시에 포함되지 않았습니다.
            var updatedLocations = result["updatedLocations"] as List<Location>;
            var newIndex = result["currentIndex"] as int;

            // pageLength와 기타 필요한 상태를 업데이트합니다.
            pageLength = updatedLocations.length;
            currentIndex = newIndex;

            // pageController를 사용하여 페이지 위치를 업데이트합니다.
            if (pageController.hasClients && pageLength > 0) {
              pageController.animateToPage(
                newIndex,
                duration: Duration(milliseconds: 600),
                curve: Curves.easeOut,
              );
            }

            // 가정: 현재 위치(location) 업데이트 로직
            location = updatedLocations.isNotEmpty
                ? updatedLocations[newIndex]
                : updatedLocations[currentIndex];

            // 필요한 추가 데이터 업데이트 로직
            _updateLocationAndWeatherData(location!);
          })
        });
    // final config = Configuration.local([Location.schema]);
    // var realm = Realm(config);
    // final List<Location> locations = realm.all<Location>().toList();
    // int currentIndex = locations.indexWhere((loc) => loc.id == location.id);
    //
    // setState(() {
    //   realm.write(() {
    //     var locationToRemove = realm.query<Location>('id == $id').firstOrNull;
    //     print('locationToRemove >>> ${locationToRemove!.id}');
    //     print('locationToRemove >>> ${locationToRemove!.name}');
    //     if (locationToRemove != null) {
    //       realm.delete(locationToRemove);
    //     }
    //   });
    // });
    //
    // setState(() {
    //   location = locations[currentIndex - 1];
    //   // pageLength Update
    //   pageLength = (locations.length - 1);
    //   // pagePoint Update to last
    //   if (pageController.hasClients && pageLength > 0) {
    //     pageController.animateToPage(
    //       currentIndex - 1,
    //       duration: Duration(milliseconds: 600),
    //       curve: Curves.easeOut,
    //     );
    //   }
    // });
    // _updateLocationAndWeatherData(location);
  }

  @override
  Widget build(BuildContext context) {
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
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => _navigateToSettings(context),
          icon: Icon(Icons.settings),
        ),
        location == null
            ? SizedBox.shrink()
            : tryFetchFirstLocationId(realm!, location!)
                ? IconButton(
                    onPressed: () => removeLocationData(location!.id),
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
