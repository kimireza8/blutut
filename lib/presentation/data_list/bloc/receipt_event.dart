part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object> get props => [];
}

class FetchOprIncomingReceipts extends ReceiptEvent {

  const FetchOprIncomingReceipts(this.token, {this.searchQuery, this.page = 1});
  final String token;
  final String? searchQuery;
  final int page;

  @override
  List<Object> get props => [token, searchQuery ?? '', page];
}

class CreateReceipt extends ReceiptEvent {
  const CreateReceipt(this.token, this.receipt);
  final String token;
  final ReceiptEntity receipt;

  @override
  List<Object> get props => [token, receipt];
}
