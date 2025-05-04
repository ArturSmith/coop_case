import 'package:coop_case/data/service/api/api_service.dart';
import 'package:coop_case/data/service/mapper/store_map.dart';
import 'package:coop_case/data/service/models/store_dto.dart';
import 'package:coop_case/domain/entity/result.dart';
import 'package:coop_case/domain/entity/store.dart';
import 'package:coop_case/domain/repository/repository.dart';

class RepositoryImpl extends Repository {
  final ApiService _apiService;

  RepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<Result<List<Store>>> searchStores(String query) async {
    final result = await _apiService.searchStores(query);

    switch (result) {
      case Success<List<StoreDto>>():
        final data = result.data;
        final stores = data.map((dto) => dto.toEntity()).toList();
        return Success(stores);
      case Failure<List<StoreDto>>():
        return Failure(result.message);
    }
  }
}
