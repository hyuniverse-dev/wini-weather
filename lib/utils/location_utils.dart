import 'package:mncf_weather/models/location_response.dart';

Map<String, dynamic> extractLocationData(
    LocationResponse locationFuture) {
  try {
    final locationData = locationFuture;
    return {
      'latitude': locationData.latitude,
      'longitude': locationData.longitude,
      'country': locationData.address.country,
      'city': locationData.address.city,
    };
  } catch (e) {
    print('Error occurred??: $e');
    return {};
  }
}
