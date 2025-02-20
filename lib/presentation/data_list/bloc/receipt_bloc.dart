import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/services/hive_service.dart';
import '../../../domain/entities/shipment_entity.dart';
import '../../../domain/usecases/receipt_fetch_usecase.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  ReceiptBloc({
    required ReceiptFetchUsecase receiptFetchUsecase,
    required HiveService hiveService,
  })  : _receiptFetchUsecase = receiptFetchUsecase,
        _hiveService = hiveService,
        super(ReceiptInitial()) {
    on<FetchOprIncomingReceipts>(_onFetchOprIncomingReceipts);
  }
  final ReceiptFetchUsecase _receiptFetchUsecase;
  final HiveService _hiveService;
  
  Future<void> _onFetchOprIncomingReceipts(
    FetchOprIncomingReceipts event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(ReceiptLoading());
    try {
      List<ShipmentEntity> receipts = await _receiptFetchUsecase.call(
        event.token,
        searchQuery: event.searchQuery,
        page: event.page,
      );
      await _hiveService.saveShipments(receipts);
      emit(ReceiptLoaded(receipts));
    } catch (e) {
      emit(ReceiptError(e.toString()));
    }
  }
}
