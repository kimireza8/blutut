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
  const ReceiptDetailDataLoaded(
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

class ReceiptDetailError extends ReceiptDetailState {
  const ReceiptDetailError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
