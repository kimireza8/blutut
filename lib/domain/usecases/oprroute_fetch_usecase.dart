import '../entities/route_entity.dart';
import '../repositories/data_repository.dart';

class OprrouteFetchUsecase {
  final DataRepository _dataRepository;

  OprrouteFetchUsecase({required DataRepository dataRepository})
      : _dataRepository = dataRepository;

  Future<List<RouteEntity>> call() async {
    List<RouteEntity> routes = await _dataRepository.getRouteData();
    return routes;
  }
}
