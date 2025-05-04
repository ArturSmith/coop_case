import 'package:coop_case/domain/repository/repository.dart';
import 'package:coop_case/utils/custom_url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repository/repository_impl.dart';
import '../data/service/api/api_service.dart';
import '../domain/usecase/search_stores_use_case.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => ApiServiceImpl() as ApiService),
    Provider(
      create:
          (context) => RepositoryImpl(apiService: context.read()) as Repository,
    ),
    Provider(
      create: (context) => SearchStoresUseCase(repository: context.read()),
    ),
    Provider(create: (contex) => CustomUrlLauncherImpl() as CustomUrlLauncher),
  ];
}
