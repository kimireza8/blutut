import '../entities/consignee_city_entity.dart';
import '../repositories/data_repository.dart';

class CityFetchUsecase {
  CityFetchUsecase({required this.dataRepository});
  final DataRepository dataRepository;

  Future<List<ConsigneeCityEntity>> call() async {
    List<ConsigneeCityEntity> cities = await dataRepository.getConsigneeCityData();
    return cities;
  }
}
