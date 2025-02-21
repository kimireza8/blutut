import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/city_entity.dart';
import '../../../../domain/entities/organization_entity.dart';
import '../../../../domain/entities/relation_entity.dart';
import '../../../../domain/entities/route_entity.dart';
import '../../../../domain/usecases/city_fetch_usecase.dart';
import '../../../../domain/usecases/oprroute_fetch_usecase.dart';
import '../../../../domain/usecases/organization_fetch_usecase.dart';
import '../../../../domain/usecases/relation_fetch_usecase.dart';

part 'data_provider_state.dart';

class DataProviderCubit extends Cubit<DataProviderState> {
  DataProviderCubit({
    required RelationFetchUsecase relationFetchUsecase,
    required OprrouteFetchUsecase oprrouteFetchUsecase,
    required OrganizationFetchUsecase organizationFetchUsecase,
    required CityFetchUsecase cityFetchUsecase,
  })  : _relationFetchUsecase = relationFetchUsecase,
        _organizationFetchUsecase = organizationFetchUsecase,
        _cityFetchUsecase = cityFetchUsecase,
        _oprrouteFetchUsecase = oprrouteFetchUsecase,
        super(DataProviderInitial());
  final RelationFetchUsecase _relationFetchUsecase;
  final OprrouteFetchUsecase _oprrouteFetchUsecase;
  final OrganizationFetchUsecase _organizationFetchUsecase;
  final CityFetchUsecase _cityFetchUsecase;

  Future<void> fetchData() async {
    emit(DataProviderLoading());
    List<RelationEntity> relation = await _relationFetchUsecase.call();
    List<RouteEntity> route = await _oprrouteFetchUsecase.call();
    List<OrganizationEntity> organization =
        await _organizationFetchUsecase.call();
    List<CityEntity> city = await _cityFetchUsecase.call();
    emit(DataProviderLoaded(route, relation, city, organization));
  }
}
