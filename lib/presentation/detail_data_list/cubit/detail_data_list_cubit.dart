import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../domain/entities/detail_shipment_entity.dart';
import '../../../domain/usecases/receipt_detail_usecase.dart';

part 'detail_data_list_state.dart';

class DetailDataListCubit extends Cubit<DetailDataListState> {
  DetailDataListCubit(
    this._receiptDetailUsecase,
    this._sharedPreferencesService,
  ) : super(DetailDataListInitial());

  final ReceiptDetailUsecase _receiptDetailUsecase;
  final SharedPreferencesService _sharedPreferencesService;

  Future<void> onFetchDetailDataList(String cookie, String id) async {
    emit(DetailDataListLoading());
    try {
      String? cookie = _sharedPreferencesService.getCookie();
      DetailShipmentEntity detailShipmentEntity =
          await _receiptDetailUsecase.call(cookie!, id);
      emit(DetailDataListLoaded(detailShipmentEntity));
    } catch (e) {
      emit(DetailDataListError(e.toString()));
    }
  }
}
