part of 'data_provider_cubit.dart';

sealed class DataProviderState extends Equatable {
  const DataProviderState();

  @override
  List<Object> get props => [];
}

final class DataProviderInitial extends DataProviderState {}

final class DataProviderLoading extends DataProviderState {}

final class DataProviderLoaded extends DataProviderState {
  final List<RouteEntity> route;
  final List<RelationEntity> relation;

  const DataProviderLoaded(this.route, this.relation);

  @override
  List<Object> get props => [route, relation];
}

final class DataProviderError extends DataProviderState {
  final String message;

  const DataProviderError(this.message);

  @override
  List<Object> get props => [message];
}
