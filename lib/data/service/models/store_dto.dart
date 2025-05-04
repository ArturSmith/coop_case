import 'package:coop_case/data/service/models/openin_hours_dto.dart';

class StoreDto {
  final String name;
  final String address;
  final String zip;
  final String city;
  final String chain;
  final String url;
  final List<OpeningHoursDto> openingHours;
  final double? latitude;
  final double? longitude;

  StoreDto({
    required this.name,
    required this.address,
    required this.zip,
    required this.city,
    required this.chain,
    required this.url,
    required this.openingHours,
    this.latitude,
    this.longitude,
  });

  factory StoreDto.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};
    final location = json['location'] as Map<String, dynamic>?;

    final openingList =
        (json['openingHours'] as List<dynamic>?)
            ?.map((e) => OpeningHoursDto.fromJson(e))
            .toList() ??
        [];

    return StoreDto(
      name: json['title'] ?? '',
      address: address['street'] ?? '',
      zip: address['zipCode'] ?? '',
      city: address['city'] ?? '',
      chain: json['chainDisplayName'] ?? '',
      url: json['url'] ?? '',
      openingHours: openingList,
      latitude: location?['latitude']?.toDouble(),
      longitude: location?['longitude']?.toDouble(),
    );
  }
}
