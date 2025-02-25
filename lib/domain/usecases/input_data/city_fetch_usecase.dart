import '../../entities/input_data/consignee_city_entity.dart';
import '../../repositories/input_data_repository.dart';

class CityFetchUsecase {
  CityFetchUsecase(this.inputDataRepository);
  final InputDataRepository inputDataRepository;

  Future<List<ConsigneeCityEntity>> call() async {
    List<ConsigneeCityEntity> cities =
        await inputDataRepository.getConsigneeCityData();
    return cities;
  }
}
