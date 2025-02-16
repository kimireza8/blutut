part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object> get props => [];
}

class FetchOprIncomingReceipts extends ReceiptEvent {

  const FetchOprIncomingReceipts(this.token);
  final String token;

  @override
  List<Object> get props => [token];
}
