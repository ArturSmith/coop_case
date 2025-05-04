import 'package:coop_case/data/service/models/openin_hours_dto.dart';
import 'package:coop_case/domain/entity/opening_hour.dart';

import '../../../domain/entity/store.dart';
import '../models/store_dto.dart';

extension StoreMapper on StoreDto {
  Store toEntity() {
    final imageUrl = "https://www.coop.no$url";
    final hours = openingHours.map((element) => element.toEntity()).toList();
    return Store(
      name: name,
      address: address,
      zip: zip,
      city: city,
      chain: chain,
      url: imageUrl,
      openingHours: hours,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

extension OpeningHoursMapper on OpeningHoursDto {
  OpeningHours toEntity() {
    return OpeningHours(day: day, timeText: timeText);
  }
}
