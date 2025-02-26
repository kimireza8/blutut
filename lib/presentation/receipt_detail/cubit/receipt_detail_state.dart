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

class ReceiptDetailError extends ReceiptDetailState {
  const ReceiptDetailError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
