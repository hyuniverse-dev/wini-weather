class LocationResponse {
  final String licence;
  final String latitude;
  final String longitude;
  final String name;
  final Address address;
  final NameDetails nameDetails;

  LocationResponse(
      {required this.licence,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.address,
      required this.nameDetails});

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      licence: json['licence'] ?? 'No Data',
      latitude: json['lat'] ?? '0.0',
      longitude: json['lon'] ?? '0.0',
      name: json['name'] ?? 'No Data',
      address: Address?.fromJson(json['address'] ?? {}),
      nameDetails: NameDetails?.fromJson(json['namedetails'] ?? {}),
    );
  }
}

class Address {
  final String? city;
  final String country;

  Address({
    required this.city,
    required this.country,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] ?? json['country'],
      country: json['country'],
    );
  }
}

class NameDetails {
  final String? name;
  final String? officialNameEn;

  NameDetails({
    required this.name,
    required this.officialNameEn,
  });

  factory NameDetails.fromJson(Map<String, dynamic> json) {
    return NameDetails(
      name: json['name'],
      officialNameEn: json['official_name:en'],
    );
  }
}
