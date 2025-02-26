import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/input_data/consignee_city_entity.dart';
import '../../../domain/entities/input_data/service_type_entity.dart';
import '../../../domain/entities/input_data/organization_entity.dart';
import '../../../domain/entities/input_data/relation_entity.dart';
import '../../../domain/entities/input_data/route_entity.dart';
import '../../../domain/entities/receipt/receipt_detail_entity.dart';
import '../../../domain/usecases/input_data/city_fetch_usecase.dart';
import '../../../domain/usecases/input_data/service_type_fetch_usecase.dart';
import '../../../domain/usecases/input_data/organization_fetch_usecase.dart';
import '../../../domain/usecases/input_data/relation_fetch_usecase.dart';
import '../../../domain/usecases/input_data/route_fetch_usecase.dart';
import '../../../domain/usecases/receipt/receipt_detail_usecase.dart';

part 'receipt_detail_state.dart';

class ReceiptDetailCubit extends Cubit<ReceiptDetailState> {
  ReceiptDetailCubit._(
    this._receiptDetailUsecase,
    this._sharedPreferencesService,
    this._relationFetchUsecase,
    this._oprrouteFetchUsecase,
    this._organizationFetchUsecase,
    this._cityFetchUsecase,
    this._serviceTypeFetchUsecase,
  ) : super(ReceiptDetailInitial());

  factory ReceiptDetailCubit.create() => ReceiptDetailCubit._(
        serviceLocator<ReceiptDetailUsecase>(),
        serviceLocator<SharedPreferencesService>(),
        serviceLocator<RelationFetchUsecase>(),
        serviceLocator<RouteFetchUsecase>(),
        serviceLocator<OrganizationFetchUsecase>(),
        serviceLocator<CityFetchUsecase>(),
        serviceLocator<ServiceTypeFetchUsecase>(),
      );

  final ReceiptDetailUsecase _receiptDetailUsecase;
  final SharedPreferencesService _sharedPreferencesService;
  final RelationFetchUsecase _relationFetchUsecase;
  final RouteFetchUsecase _oprrouteFetchUsecase;
  final OrganizationFetchUsecase _organizationFetchUsecase;
  final CityFetchUsecase _cityFetchUsecase;
  final ServiceTypeFetchUsecase _serviceTypeFetchUsecase;

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

  Future<void> fetchData() async {
    emit(ReceiptDetailLoading());
    List<RelationEntity> relation = await _relationFetchUsecase.call();
    List<RouteEntity> route = await _oprrouteFetchUsecase.call();
    List<OrganizationEntity> organization =
        await _organizationFetchUsecase.call();
    List<ConsigneeCityEntity> city = await _cityFetchUsecase.call();
    List<ServiceTypeEntity> serviceType =
        await _serviceTypeFetchUsecase.call();
    emit(
      ReceiptDetailDataLoaded(
        route,
        relation,
        city,
        organization,
        serviceType,
      ),
    );
  }
}
