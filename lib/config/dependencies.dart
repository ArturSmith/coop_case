import 'package:coop_case/domain/repository/Repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repository/RepositoryImpl.dart';
import '../data/service/api/ApiService.dart';
import '../domain/usecase/SearchStoresUseCase.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (_) => ApiService()),
    Provider(
      create:
          (context) => RepositoryImpl(apiService: context.read()) as Repository,
    ),
    Provider(
      create: (context) => SearchStoresUseCase(repository: context.read()),
    ),
  ];
}
