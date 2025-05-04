import 'package:coop_case/data/repository/repository_impl.dart';
import 'package:coop_case/data/service/api/api_service.dart';
import 'package:coop_case/data/service/models/store_dto.dart';
import 'package:coop_case/domain/entity/result.dart';
import 'package:coop_case/domain/entity/store.dart';
import 'package:coop_case/domain/repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late ApiService mockApiService;
  late Repository repository;

  setUp(() {
    mockApiService = MockApiService();
    repository = RepositoryImpl(apiService: mockApiService);
  });

  test('returns Success with list of stores when API call succeeds', () async {
    final dto = StoreDto(
      name: "Test Store",
      address: "123 Test St",
      zip: "12345",
      city: "Testville",
      chain: "TestChain",
      url: "https://example.com",
      openingHours: [],
      latitude: 10.0,
      longitude: 20.0,
    );

    when(
      () => mockApiService.searchStores("test"),
    ).thenAnswer((_) async => Success<List<StoreDto>>([dto]));

    final result = await repository.searchStores("test");

    expect(result, isA<Success<List<Store>>>());

    final stores = (result as Success<List<Store>>).data;
    expect(stores.length, 1);
    expect(stores.first.name, "Test Store");
  });

  test('returns Failure when API call fails', () async {
    when(
      () => mockApiService.searchStores("fail"),
    ).thenAnswer((_) async => Failure<List<StoreDto>>("Network error"));

    final result = await repository.searchStores("fail");

    expect(result, isA<Failure<List<Store>>>());
    expect((result as Failure).message, "Network error");
  });
}
