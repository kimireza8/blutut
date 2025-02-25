import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../dependency_injections.dart';
import '../../../domain/entities/input_data/consignee_city_entity.dart';
import '../../../domain/entities/input_data/kind_of_service_entity.dart';
import '../../../domain/entities/input_data/organization_entity.dart';
import '../../../domain/entities/input_data/relation_entity.dart';
import '../../../domain/entities/input_data/route_entity.dart';
import '../../../domain/entities/receipt/receipt_input_entity.dart';
import '../../../domain/usecases/input_data/city_fetch_usecase.dart';
import '../../../domain/usecases/input_data/kind_of_service_fetch_usecase.dart';
import '../../../domain/usecases/input_data/organization_fetch_usecase.dart';
import '../../../domain/usecases/input_data/relation_fetch_usecase.dart';
import '../../../domain/usecases/input_data/route_fetch_usecase.dart';
import '../../../domain/usecases/receipt/receipt_create_usecase.dart';

part 'input_state.dart';

class InputCubit extends Cubit<InputState> {
  InputCubit._({
    required RelationFetchUsecase relationFetchUsecase,
    required RouteFetchUsecase oprrouteFetchUsecase,
    required OrganizationFetchUsecase organizationFetchUsecase,
    required CityFetchUsecase cityFetchUsecase,
    required KindofServiceFetchUsecase kindOfServiceUsecase,
    required ReceiptCreateUsecase receiptCreateUsecase,
  })  : _relationFetchUsecase = relationFetchUsecase,
        _organizationFetchUsecase = organizationFetchUsecase,
        _cityFetchUsecase = cityFetchUsecase,
        _oprrouteFetchUsecase = oprrouteFetchUsecase,
        _kindofServiceUsecase = kindOfServiceUsecase,
        _receiptCreateUsecase = receiptCreateUsecase,
        super(InputInitial());

  factory InputCubit.create() => InputCubit._(
      relationFetchUsecase: serviceLocator<RelationFetchUsecase>(),
      oprrouteFetchUsecase: serviceLocator<RouteFetchUsecase>(),
      organizationFetchUsecase: serviceLocator<OrganizationFetchUsecase>(),
      cityFetchUsecase: serviceLocator<CityFetchUsecase>(),
      kindOfServiceUsecase: serviceLocator<KindofServiceFetchUsecase>(),
      receiptCreateUsecase: serviceLocator<ReceiptCreateUsecase>(),
    );

  final RelationFetchUsecase _relationFetchUsecase;
  final RouteFetchUsecase _oprrouteFetchUsecase;
  final OrganizationFetchUsecase _organizationFetchUsecase;
  final CityFetchUsecase _cityFetchUsecase;
  final KindofServiceFetchUsecase _kindofServiceUsecase;
  final ReceiptCreateUsecase _receiptCreateUsecase;

  Future<void> fetchData() async {
    emit(InputLoading());
    List<RelationEntity> relation = await _relationFetchUsecase.call();
    List<RouteEntity> route = await _oprrouteFetchUsecase.call();
    List<OrganizationEntity> organization =
        await _organizationFetchUsecase.call();
    List<ConsigneeCityEntity> city = await _cityFetchUsecase.call();
    List<KindOfServiceEntity> kindOfService =
        await _kindofServiceUsecase.call();
    emit(
      InputLoaded(
        route,
        relation,
        city,
        organization,
        kindOfService,
      ),
    );
  }

  Future<void> createReceipt(String cookie, ReceiptInputEntity receipt) async {
    emit(InputLoading());
    try {
      await _receiptCreateUsecase.call(cookie, receipt);
      emit(InputSuccess());
    } catch (e) {
      emit(InputError(message: 'Error creating receipt: ${e.toString()}'));
    }
  }
}
