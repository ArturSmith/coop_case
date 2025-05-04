import 'package:coop_case/domain/entity/result.dart';
import '../entity/store.dart';

abstract class Repository {
  Future<Result<List<Store>>> searchStores(String query);
}
