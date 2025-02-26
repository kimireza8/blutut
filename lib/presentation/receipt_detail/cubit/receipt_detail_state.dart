part of 'receipt_detail_cubit.dart';

@immutable
abstract class ReceiptDetailState extends Equatable {
  const ReceiptDetailState();

  @override
  List<Object> get props => [];
}

class ReceiptDetailInitial extends ReceiptDetailState {}

class ReceiptDetailLoading extends ReceiptDetailState {}

class ReceiptDetailLoaded extends ReceiptDetailState {
  const ReceiptDetailLoaded(this.detailReceiptEntity);
  final ReceiptDetailEntity detailReceiptEntity;

  @override
  List<Object> get props => [detailReceiptEntity];
}

class ReceiptDetailDataLoaded extends ReceiptDetailState {
  const ReceiptDetailDataLoaded({
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

class ReceiptDetailError extends ReceiptDetailState {
  const ReceiptDetailError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
