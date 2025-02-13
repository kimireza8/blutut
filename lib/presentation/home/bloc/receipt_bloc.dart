import 'package:blutut_clasic/domain/usecase/receipt_fetch_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final ReceiptFetchUsecase _receiptFetchUsecase;

  ReceiptBloc({required ReceiptFetchUsecase receiptFetchUsecase}) : _receiptFetchUsecase = receiptFetchUsecase, super(ReceiptInitial()) {
    on<FetchOprIncomingReceipts>(_onFetchOprIncomingReceipts);
  }

  Future<void> _onFetchOprIncomingReceipts(
    FetchOprIncomingReceipts event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(ReceiptLoading());
    try {
      final receipts = await _receiptFetchUsecase.call(event.token);
      emit(ReceiptLoaded(receipts));
    } catch (e) {
      emit(ReceiptError(e.toString()));
    }
  }
}
