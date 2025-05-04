import 'package:coop_case/domain/entity/result.dart';
import 'package:coop_case/domain/entity/store.dart';

import '../repository/repository.dart';

class SearchStoresUseCase {
  final Repository _repository;

  SearchStoresUseCase({required Repository repository})
    : _repository = repository;

  Future<Result<List<Store>>> searchStores(String query) async {
    return await _repository.searchStores(query);
  }
}
