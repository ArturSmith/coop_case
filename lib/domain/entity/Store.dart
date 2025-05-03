class Store {
  final String name;
  final String address;
  final String zip;
  final String city;
  final String chain;
  final String url;
  final Map<String, String> openingHours;
  final double? latitude;
  final double? longitude;

  Store({
    required this.name,
    required this.address,
    required this.zip,
    required this.city,
    required this.chain,
    required this.url,
    required this.openingHours,
    required this.latitude,
    required this.longitude,
  });
}
