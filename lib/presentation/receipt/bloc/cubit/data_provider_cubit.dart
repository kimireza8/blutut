import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/relation_entity.dart';
import '../../../../domain/entities/route_entity.dart';
import '../../../../domain/usecases/oprroute_fetch_usecase.dart';
import '../../../../domain/usecases/relation_fetch_usecase.dart';

part 'data_provider_state.dart';

class DataProviderCubit extends Cubit<DataProviderState> {
  final RelationFetchUsecase _relationFetchUsecase;
  final OprrouteFetchUsecase _oprrouteFetchUsecase;

  DataProviderCubit({
    required RelationFetchUsecase relationFetchUsecase,
    required OprrouteFetchUsecase oprrouteFetchUsecase,
  })  : _relationFetchUsecase = relationFetchUsecase,
        _oprrouteFetchUsecase = oprrouteFetchUsecase,
        super(DataProviderInitial());

  Future<void> fetchData() async {
    emit(DataProviderLoading());
    final List<RelationEntity> relation = await _relationFetchUsecase.call();
    final List<RouteEntity> route = await _oprrouteFetchUsecase.call();
    print('Data Provider relasi : ${relation.length}');
    print('Data Provider rute : ${route.length}');
    emit(DataProviderLoaded(route, relation));
  }
}
