part of 'receipt_bloc.dart';

@immutable
abstract class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object> get props => [];
}

class ReceiptInitial extends ReceiptState {}

class ReceiptLoading extends ReceiptState {}

class ReceiptLoaded extends ReceiptState {

  const ReceiptLoaded(this.receipts);
  final List<ShipmentEntity> receipts;

  @override
  List<Object> get props => [receipts];
}

class ReceiptError extends ReceiptState {

  const ReceiptError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
