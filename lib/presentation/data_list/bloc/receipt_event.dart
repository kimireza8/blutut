part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object> get props => [];
}

class FetchOprIncomingReceipts extends ReceiptEvent {

  const FetchOprIncomingReceipts(this.token, {this.searchQuery});
  final String token;
  final String? searchQuery;

  @override
  List<Object> get props => [token, searchQuery ?? ''];
}
