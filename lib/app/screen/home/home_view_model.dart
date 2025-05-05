import 'package:coop_case/app/screen/home/home_screen_state.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/result.dart';
import '../../../domain/entity/store.dart';
import '../../../domain/usecase/search_stores_use_case.dart';

class HomeViewModel {
  final SearchStoresUseCase _searchStoresUseCase;
  final TextEditingController controller = TextEditingController();

  HomeViewModel({required SearchStoresUseCase searchStoresUseCase})
    : _searchStoresUseCase = searchStoresUseCase;

  final ValueNotifier<HomeState> state = ValueNotifier(HomeInitial());

  Future<void> searchStores(String query) async {
    if (query.trim().isEmpty) {
      _setState(HomeError("Enter store zip or name"));
      return;
    }

    _setState(HomeLoading());

    final result = await _searchStoresUseCase.searchStores(query.trim());

    if (result is Success<List<Store>>) {
      if (result.data.isEmpty) {
        _setState(HomeError("Stores not found"));
      } else {
        _setState(HomeLoaded(result.data));
      }
    } else if (result is Failure<List<Store>>) {
      _setState(HomeError(result.message));
    }
  }

  void _setState(HomeState state) {
    this.state.value = state;
  }
}
