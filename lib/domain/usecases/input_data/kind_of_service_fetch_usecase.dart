import '../../entities/input_data/kind_of_service_entity.dart';
import '../../repositories/input_data_repository.dart';

class KindofServiceFetchUsecase {
  KindofServiceFetchUsecase(this.inputDataRepository);
  final InputDataRepository inputDataRepository;

  Future<List<KindOfServiceEntity>> call() async {
    List<KindOfServiceEntity> kindOfService =
        await inputDataRepository.getKindofServiceData();
    return kindOfService;
  }
}
