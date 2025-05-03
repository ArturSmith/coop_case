import 'package:coop_case/domain/entity/Result.dart';
import 'package:coop_case/domain/entity/Store.dart';

import '../repository/Repository.dart';

class SearchStoresUseCase {

  final Repository _repository;

  SearchStoresUseCase({required Repository repository})
      : _repository = repository;

  Future<Result<List<Store>>> searchStores(String query) async {
    return await _repository.searchStores(query);
  }
}