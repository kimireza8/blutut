import '../entities/city_entity.dart';
import '../repositories/data_repository.dart';

class CityFetchUsecase {
  final DataRepository dataRepository;

  CityFetchUsecase({required this.dataRepository});

  Future<List<CityEntity>> call() async {
    List<CityEntity> cities = await dataRepository.getCityData();
    return cities;
  }
}
