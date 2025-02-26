part of 'input_cubit.dart';

sealed class InputState extends Equatable {
  const InputState();

  @override
  List<Object> get props => [];
}

final class InputInitial extends InputState {}

final class InputLoading extends InputState {}

final class InputLoaded extends InputState {
  const InputLoaded(
    this.route,
    this.relation,
    this.city,
    this.organization,
    this.serviceType,
  );
  final List<RouteEntity> route;
  final List<RelationEntity> relation;
  final List<ConsigneeCityEntity> city;
  final List<OrganizationEntity> organization;
  final List<ServiceTypeEntity> serviceType;

  @override
  List<Object> get props => [
        route,
        relation,
        city,
        organization,
        serviceType,
      ];
}

final class InputError extends InputState {
  const InputError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

final class InputSuccess extends InputState {}
