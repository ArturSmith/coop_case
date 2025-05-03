import '../../../domain/entity/Store.dart';
import '../models/StoreDto.dart';

extension Mapper on StoreDto {
  Store toEntity() {
    final imageUrl = "https://www.coop.no$url";
    return Store(
      name: name,
      address: address,
      zip: zip,
      city: city,
      chain: chain,
      url: imageUrl,
      openingHours: openingHours,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
