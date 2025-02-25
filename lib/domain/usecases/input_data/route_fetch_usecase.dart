import '../../entities/input_data/route_entity.dart';
import '../../repositories/input_data_repository.dart';

class RouteFetchUsecase {
  RouteFetchUsecase(this.inputDataRepository);
  final InputDataRepository inputDataRepository;

  Future<List<RouteEntity>> call() async {
    List<RouteEntity> routes = await inputDataRepository.getRouteData();
    return routes;
  }
}
