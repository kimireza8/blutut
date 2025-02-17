part of 'detail_data_list_cubit.dart';

@immutable
abstract class DetailDataListState extends Equatable {
  const DetailDataListState();

  @override
  List<Object> get props => [];
}

class DetailDataListInitial extends DetailDataListState {}

class DetailDataListLoading extends DetailDataListState {}

class DetailDataListLoaded extends DetailDataListState {
  const DetailDataListLoaded(this.detailShipmentEntity); 
  final DetailShipmentEntity detailShipmentEntity;

  @override
  List<Object> get props => [detailShipmentEntity];
}

class DetailDataListError extends DetailDataListState {
  const DetailDataListError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
