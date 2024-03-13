import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mncf_weather/models/location_response.dart';

Future<LocationResponse> fetchLocationData(String searchKeyword) async {
  const int addressDetails = 1;
  const int nameDetails = 1;
  const String format = 'jsonv2';
  const int limit = 1;
  final String url = 'https://nominatim.openstreetmap.org/search';

  final Uri uri = Uri.parse(
      '$url?addressdetails=$addressDetails&q=$searchKeyword&format=$format&limit=$limit&namedetails=$nameDetails');

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final String decodedResponse = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodedResponse);
      if (jsonData.isNotEmpty) {
        LocationResponse data = LocationResponse.fromJson(jsonData.first);
        return data; // JSON 데이터 반환
      } else {
        throw Exception('Please correct the name of your search area.222');
      }
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Please correct the name of your search area.');
  }
}