import 'package:flutter/material.dart';

import '../../models/location_response.dart';
import '../../services/location_api_service.dart';
import '../../widgets/details_screen/location_future_builder.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  static int locationFetchCount = 0;
  TextEditingController searchKeywordController = TextEditingController();
  bool isLoading = false;
  late String searchKeyword;
  late Future<LocationResponse> locationData;

  @override
  void initState() {
    locationData = fetchLocationData(searchKeyword);
    searchKeywordController.text = '';
    super.initState();
  }

  Future<LocationResponse> refreshLocation() async {
    setState(() {
      isLoading = true;
    });
    try {
      searchKeyword = searchKeywordController.text;
      locationData = fetchLocationData(searchKeyword);
      await locationData;
      // print(locationData);
      return locationData;
    } catch (e) {
      print('Error: $e');
      return throw Exception('Error: ${e}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SearchLocationScreen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isLoading
              ? [CircularProgressIndicator()]
              : [
            LocationFutureBuilder(locationData: locationData),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchKeywordController,
                decoration: InputDecoration(labelText: "Search Keyword"),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () async {
                final locationData = await refreshLocation();
                locationFetchCount++;
                print('locationData: $locationData');
                // 문자열로 지역검색 -> 위도/경도 반환
                // try {
                //   LocationResponse locationData = await fetchLocationData(
                //       searchKeywordController.text);
                String lat = locationData.latitude;
                String lon = locationData.longitude;
                //   String location = lat + ',' + lon;
                //   print('location: $location');
                //
                //   WeatherResponse weatherData =
                //       await fetchWeatherData(location);
                //   print('location.name: ${weatherData.location.name}');
                //   print(
                //       'location.country: ${weatherData.location.country}');
                //   print('current.tempC: ${weatherData.current.tempC}');
                //   print('current.feelsC: ${weatherData.current.feelsC}');
                // } catch (e) {
                //   print('Error: ${e}');
                // }
                // // 해당 위도/경도 날씨 조회
                // refreshLocation();
                // locationFetchCount++;
                print("위치검색 Button ${locationFetchCount} Clicked");
              },
              child: Text("위치검색"),
            ),
          ],
        ),
      ),
    );
  }
}