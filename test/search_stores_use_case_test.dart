import 'package:coop_case/domain/entity/result.dart';
import 'package:coop_case/domain/entity/store.dart';
import 'package:coop_case/domain/repository/repository.dart';
import 'package:coop_case/domain/usecase/search_stores_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late SearchStoresUseCase useCase;
  late Repository repository;

  final storeMock = Store(
    name: "name",
    address: "address",
    zip: "zip",
    city: "city",
    chain: "chain",
    url: "url",
    openingHours: [],
    latitude: null,
    longitude: null,
  );

  setUp(() {
    repository = MockRepository();
    useCase = SearchStoresUseCase(repository: repository);

    when(
      () => repository.searchStores("0977"),
    ).thenAnswer((_) async => Success([storeMock]));

    when(
      () => repository.searchStores("nsdknf"),
    ).thenAnswer((_) async => Failure("failed"));
  });

  test('returns Success', () async {
    final result = await useCase.searchStores("0977");

    expect(result, isA<Success<List<Store>>>());

    verify(() => repository.searchStores("0977")).called(1);
  });

  test('returns Failed', () async {
    final result = await useCase.searchStores("nsdknf");

    expect(result, isA<Failure<List<Store>>>());

    verify(() => repository.searchStores("nsdknf")).called(1);
  });
}
