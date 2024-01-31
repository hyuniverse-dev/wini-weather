import 'dart:core';

import 'package:flutter/material.dart';

import 'location_response.dart';

class LocationModel extends ChangeNotifier {
  List<LocationResponse> _locationData = [
    LocationResponse(
      licence:
          'Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright',
      latitude: '35.1799528',
      longitude: '129.0752365',
      name: 'busan',
      address: Address(
        city: '부산광역시',
        country: '대한민국',
      ),
    ),
    LocationResponse(
      licence:
          'Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright',
      latitude: '37.5666791',
      longitude: '126.9782914',
      name: 'seoul',
      address: Address(
        city: '서울특별시',
        country: '대한민국',
      ),
    ),
    LocationResponse(
      licence:
          'Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright',
      latitude: '35.000074',
      longitude: '104.999927',
      name: 'china',
      address: Address(
        city: '中国',
        country: '中国',
      ),
    ),
  ];
  List<LocationResponse> get locationData => _locationData;
  void addLocation (LocationResponse location) {
    _locationData.add(location);
    notifyListeners();
  }


}
