import 'package:coop_case/domain/entity/store.dart';

sealed class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Store> stores;
  HomeLoaded(this.stores);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
