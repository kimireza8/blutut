part of 'data_provider_cubit.dart';

sealed class DataProviderState extends Equatable {
  const DataProviderState();

  @override
  List<Object> get props => [];
}

final class DataProviderInitial extends DataProviderState {}

final class DataProviderLoading extends DataProviderState {}

final class DataProviderLoaded extends DataProviderState {
  const DataProviderLoaded(
      this.route, this.relation, this.city, this.organization);
  final List<RouteEntity> route;
  final List<RelationEntity> relation;
  final List<CityEntity> city;
  final List<OrganizationEntity> organization;

  @override
  List<Object> get props => [route, relation, city, organization];
}

final class DataProviderError extends DataProviderState {
  const DataProviderError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
