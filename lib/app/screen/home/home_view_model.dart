import 'package:flutter/material.dart';

import '../../../domain/entity/Result.dart';
import '../../../domain/entity/Store.dart';
import '../../../domain/usecase/SearchStoresUseCase.dart';

class HomeViewModel extends ChangeNotifier {
  final SearchStoresUseCase _searchStoresUseCase;

  HomeViewModel({required SearchStoresUseCase searchStoresUseCase})
    : _searchStoresUseCase = searchStoresUseCase;

  List<Store> _stores = [];

  List<Store> get stores => _stores;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  void searchStores(String query) async {
    if (query.isEmpty) {
      _error = "Enter store zip or name";
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _searchStoresUseCase.searchStores(query.trim());

    switch (result) {
      case Success<List<Store>>():
        if (result.data.isEmpty) {
          _error = "Stores not found";
          _isLoading = false;
          _stores = [];
          notifyListeners();
          return;
        }
        _stores = result.data;
      case Failure<List<Store>>():
        _stores = [];
        _error = result.message;
    }

    _isLoading = false;
    notifyListeners();
  }
}
