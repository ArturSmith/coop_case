class StoreDto {
  final String name;
  final String address;
  final String zip;
  final String city;
  final String chain;
  final String url;
  final Map<String, String> openingHours;
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
    final opening = <String, String>{};

    final openingHours = json['openingHours'] as List<dynamic>?;
    if (openingHours != null) {
      for (final day in openingHours) {
        final dayOfWeek = day['dayOfWeek']?.toString() ?? 'Unknown';
        final isClosed = day['closed'] == true;
        final from = day['from1'] ?? '';
        final to = day['to1'] ?? '';
        final time = isClosed ? 'Closed' : '$from - $to';
        opening[dayOfWeek] = time;
      }
    }

    final address = json['address'] as Map<String, dynamic>? ?? {};
    final location = json['location'] as Map<String, dynamic>?;

    return StoreDto(
      name: json['title'] ?? '',
      address: address['street'] ?? '',
      zip: address['zipCode'] ?? '',
      city: address['city'] ?? '',
      chain: json['chainDisplayName'] ?? '',
      url: json['url'] ?? '',
      openingHours: opening,
      latitude: location?['latitude']?.toDouble(),
      longitude: location?['longitude']?.toDouble(),
    );
  }
}
