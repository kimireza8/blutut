part of 'receipt_edit_cubit.dart';

@immutable
abstract class ReceiptEditState extends Equatable {
  const ReceiptEditState();

  @override
  List<Object> get props => [];
}

class ReceiptEditInitial extends ReceiptEditState {}

class ReceiptEditLoading extends ReceiptEditState {}

class ReceiptReferenceDataLoaded extends ReceiptEditState {
  const ReceiptReferenceDataLoaded({
    required this.routes,
    required this.relations,
    required this.cities,
    required this.organizations,
    required this.serviceTypes,
  });
  final List<RouteEntity> routes;
  final List<RelationEntity> relations;
  final List<ConsigneeCityEntity> cities;
  final List<OrganizationEntity> organizations;
  final List<ServiceTypeEntity> serviceTypes;

  @override
  List<Object> get props => [
        routes,
        relations,
        cities,
        organizations,
        serviceTypes,
      ];
}

class ReceiptEditError extends ReceiptEditState {
  const ReceiptEditError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

final class ReceiptEditSuccess extends ReceiptEditState {}
