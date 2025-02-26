import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../dependency_injections.dart';
import '../../../domain/entities/input_data/consignee_city_entity.dart';
import '../../../domain/entities/input_data/organization_entity.dart';
import '../../../domain/entities/input_data/relation_entity.dart';
import '../../../domain/entities/input_data/route_entity.dart';
import '../../../domain/entities/input_data/service_type_entity.dart';
import '../../../domain/usecases/input_data/city_fetch_usecase.dart';
import '../../../domain/usecases/input_data/organization_fetch_usecase.dart';
import '../../../domain/usecases/input_data/relation_fetch_usecase.dart';
import '../../../domain/usecases/input_data/route_fetch_usecase.dart';
import '../../../domain/usecases/input_data/service_type_fetch_usecase.dart';

part 'receipt_edit_state.dart';

class ReceiptEditCubit extends Cubit<ReceiptEditState> {
  factory ReceiptEditCubit.create() => ReceiptEditCubit._(
        relationFetchUsecase: serviceLocator<RelationFetchUsecase>(),
        routeFetchUsecase: serviceLocator<RouteFetchUsecase>(),
        organizationFetchUsecase: serviceLocator<OrganizationFetchUsecase>(),
        cityFetchUsecase: serviceLocator<CityFetchUsecase>(),
        serviceTypeFetchUsecase: serviceLocator<ServiceTypeFetchUsecase>(),
      );

  ReceiptEditCubit._({
    required RelationFetchUsecase relationFetchUsecase,
    required RouteFetchUsecase routeFetchUsecase,
    required OrganizationFetchUsecase organizationFetchUsecase,
    required CityFetchUsecase cityFetchUsecase,
    required ServiceTypeFetchUsecase serviceTypeFetchUsecase,
  })  : _relationFetchUsecase = relationFetchUsecase,
        _routeFetchUsecase = routeFetchUsecase,
        _organizationFetchUsecase = organizationFetchUsecase,
        _cityFetchUsecase = cityFetchUsecase,
        _serviceTypeFetchUsecase = serviceTypeFetchUsecase,
        super(ReceiptEditInitial());

  final RelationFetchUsecase _relationFetchUsecase;
  final RouteFetchUsecase _routeFetchUsecase;
  final OrganizationFetchUsecase _organizationFetchUsecase;
  final CityFetchUsecase _cityFetchUsecase;
  final ServiceTypeFetchUsecase _serviceTypeFetchUsecase;

  Future<void> fetchReferenceData() async {
    emit(ReceiptEditLoading());

    try {
      List<List<Object>> results = await Future.wait([
        _relationFetchUsecase.call(),
        _routeFetchUsecase.call(),
        _organizationFetchUsecase.call(),
        _cityFetchUsecase.call(),
        _serviceTypeFetchUsecase.call(),
      ]);

      var relations = results[0] as List<RelationEntity>;
      var routes = results[1] as List<RouteEntity>;
      var organizations = results[2] as List<OrganizationEntity>;
      var cities = results[3] as List<ConsigneeCityEntity>;
      var serviceTypes = results[4] as List<ServiceTypeEntity>;

      emit(
        ReceiptReferenceDataLoaded(
          routes: routes,
          relations: relations,
          cities: cities,
          organizations: organizations,
          serviceTypes: serviceTypes,
        ),
      );
    } catch (e) {
      emit(ReceiptEditError(e.toString()));
    }
  }
}
