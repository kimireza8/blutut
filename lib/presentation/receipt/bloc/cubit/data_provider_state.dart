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
    this.route,
    this.relation,
    this.city,
    this.organization,
    this.kindOfService,
  );
  final List<RouteEntity> route;
  final List<RelationEntity> relation;
  final List<ConsigneeCityEntity> city;
  final List<OrganizationEntity> organization;
  final List<KindOfServiceEntity> kindOfService;

  @override
  List<Object> get props => [
        route,
        relation,
        city,
        organization,
        kindOfService,
      ];
}

final class DataProviderError extends DataProviderState {
  const DataProviderError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
