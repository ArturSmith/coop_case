import 'package:coop_case/app/screen/home/home_screen_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:coop_case/domain/entity/result.dart';
import 'package:coop_case/domain/entity/store.dart';
import 'package:coop_case/domain/usecase/search_stores_use_case.dart';
import 'package:coop_case/app/screen/home/home_view_model.dart';

import 'home_view_model_test.mocks.dart';

@GenerateMocks([SearchStoresUseCase])
void main() {
  late HomeViewModel viewModel;
  late MockSearchStoresUseCase mockSearchStoresUseCase;

  setUpAll(() {
    provideDummy<Result<List<Store>>>(Success([]));
  });

  setUp(() {
    mockSearchStoresUseCase = MockSearchStoresUseCase();
    viewModel = HomeViewModel(searchStoresUseCase: mockSearchStoresUseCase);
  });

  group('HomeViewModel Tests', () {
    test('initial state should be empty', () {
      expect(viewModel.state.value, isA<HomeInitial>());
    });

    test('searchStores with empty query should set error', () async {
      await viewModel.searchStores('');

      expect(viewModel.state.value, isA<HomeError>());
      verifyNever(mockSearchStoresUseCase.searchStores(any));
    });

    test(
      'searchStores with valid query should update state correctly',
      () async {
        final mockStores = [
          Store(
            name: 'Store 1',
            address: 'Address 1',
            zip: '12345',
            city: 'City 1',
            chain: 'Chain 1',
            url: 'https://example.com',
            openingHours: [],
            latitude: 10.0,
            longitude: 20.0,
          ),
          Store(
            name: 'Store 2',
            address: 'Address 2',
            zip: '54321',
            city: 'City 2',
            chain: 'Chain 2',
            url: 'https://example.com',
            openingHours: [],
            latitude: 30.0,
            longitude: 40.0,
          ),
        ];

        when(
          mockSearchStoresUseCase.searchStores('test'),
        ).thenAnswer((_) async => Success(mockStores));

        await viewModel.searchStores('test');

        expect(viewModel.state.value, isA<HomeLoaded>());
        verify(mockSearchStoresUseCase.searchStores('test')).called(1);
      },
    );

    test('searchStores with no results should set error', () async {
      when(
        mockSearchStoresUseCase.searchStores('test'),
      ).thenAnswer((_) async => Success([]));

      await viewModel.searchStores('test');

      expect(viewModel.state.value, isA<HomeError>());
      verify(mockSearchStoresUseCase.searchStores('test')).called(1);
    });

    test('searchStores with failure should set error', () async {
      when(
        mockSearchStoresUseCase.searchStores('test'),
      ).thenAnswer((_) async => Failure('Error occurred'));

      await viewModel.searchStores('test');

      expect(viewModel.state.value, isA<HomeError>());
      verify(mockSearchStoresUseCase.searchStores('test')).called(1);
    });
  });
}
