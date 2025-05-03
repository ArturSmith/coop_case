import 'package:coop_case/data/service/api/ApiService.dart';
import 'package:coop_case/data/service/mapper/StoreMap.dart';
import 'package:coop_case/data/service/models/StoreDto.dart';
import 'package:coop_case/domain/entity/Result.dart';
import 'package:coop_case/domain/entity/Store.dart';
import 'package:coop_case/domain/repository/Repository.dart';

class RepositoryImpl extends Repository {
  final ApiService _apiService;

  RepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<Result<List<Store>>> searchStores(String query) async {
    final result = await _apiService.searchStores(query);

    switch (result) {
      case Success<List<StoreDto>>():
        final data = result.data;
        print("DATA check: $data");
        final stores = data.map((dto) => dto.toEntity()).toList();
        return Success(stores);
      case Failure<List<StoreDto>>():
        print("DATA check 2: ${result.message}");
        return Failure(result.message);
    }
  }
}
