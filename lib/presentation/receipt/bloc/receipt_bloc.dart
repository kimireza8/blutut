import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/services/hive_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/receipt/receipt_entity.dart';
import '../../../domain/entities/receipt/receipt_input_entity.dart';
import '../../../domain/usecases/receipt/receipt_create_usecase.dart';
import '../../../domain/usecases/receipt/receipt_fetch_usecase.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  ReceiptBloc._({
    required ReceiptFetchUsecase receiptFetchUsecase,
    required HiveService hiveService,
    required ReceiptCreateUsecase receiptCreateUsecase,
  })  : _receiptFetchUsecase = receiptFetchUsecase,
        _hiveService = hiveService,
        _receiptCreateUsecase = receiptCreateUsecase,
        super(ReceiptInitial()) {
    on<FetchOperationalIncomingReceipts>(_onFetchOperationalIncomingReceipts);
    on<CreateReceipt>(_onCreateReceipt);
  }

  factory ReceiptBloc.create() => ReceiptBloc._(
        receiptFetchUsecase: serviceLocator<ReceiptFetchUsecase>(),
        hiveService: serviceLocator<HiveService>(),
        receiptCreateUsecase: serviceLocator<ReceiptCreateUsecase>(),
      );

  final ReceiptFetchUsecase _receiptFetchUsecase;
  final HiveService _hiveService;
  final ReceiptCreateUsecase _receiptCreateUsecase;

  Future<void> _onFetchOperationalIncomingReceipts(
    FetchOperationalIncomingReceipts event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(ReceiptLoading());
    try {
      List<ReceiptEntity> receipts = await _receiptFetchUsecase.call(
        event.token,
        searchQuery: event.searchQuery,
        page: event.page,
      );
      await _hiveService.saveReceipts(receipts);
      emit(ReceiptLoaded(receipts));
    } catch (e) {
      emit(ReceiptError(e.toString()));
    }
  }

  Future<void> _onCreateReceipt(
    CreateReceipt event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(ReceiptLoading());
    try {
      await _receiptCreateUsecase.call(event.token, event.receipt);
      emit(ReceiptSuccess());
    } catch (e) {
      emit(ReceiptError(e.toString()));
    }
  }
}
