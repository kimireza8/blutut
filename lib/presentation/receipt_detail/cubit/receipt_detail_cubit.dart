import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/receipt/receipt_detail_entity.dart';
import '../../../domain/usecases/receipt/receipt_detail_usecase.dart';

part 'receipt_detail_state.dart';

class ReceiptDetailCubit extends Cubit<ReceiptDetailState> {
  ReceiptDetailCubit._(
    this._receiptDetailUsecase,
    this._sharedPreferencesService,
  ) : super(ReceiptDetailInitial());

  factory ReceiptDetailCubit.create() => ReceiptDetailCubit._(
        serviceLocator<ReceiptDetailUsecase>(),
        serviceLocator<SharedPreferencesService>(),
      );

  final ReceiptDetailUsecase _receiptDetailUsecase;
  final SharedPreferencesService _sharedPreferencesService;

  Future<void> fetchReceiptDetail(String id) async {
    emit(ReceiptDetailLoading());
    try {
      String? cookie = _sharedPreferencesService.getCookie();
      if (cookie == null) {
        emit(const ReceiptDetailError('No authentication token found'));
        return;
      }

      ReceiptDetailEntity detailReceiptEntity =
          await _receiptDetailUsecase.call(cookie, id);
      emit(ReceiptDetailLoaded(detailReceiptEntity));
    } catch (e) {
      emit(ReceiptDetailError(e.toString()));
    }
  }
}
