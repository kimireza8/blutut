import '../entities/route_entity.dart';
import '../repositories/data_repository.dart';

class OprrouteFetchUsecase {
  OprrouteFetchUsecase({required DataRepository dataRepository})
      : _dataRepository = dataRepository;
  final DataRepository _dataRepository;

  Future<List<RouteEntity>> call() async {
    List<RouteEntity> routes = await _dataRepository.getRouteData();
    return routes;
  }
}
