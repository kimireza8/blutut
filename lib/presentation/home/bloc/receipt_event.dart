part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object> get props => [];
}

class FetchOprIncomingReceipts extends ReceiptEvent {
  final String token;

  const FetchOprIncomingReceipts(this.token);

  @override
  List<Object> get props => [token];
}
