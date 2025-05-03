import 'package:coop_case/domain/entity/Result.dart';
import '../entity/Store.dart';

abstract class Repository {
  Future<Result<List<Store>>> searchStores(String query);
}
