import '../entities/kind_of_service_entity.dart';
import '../repositories/data_repository.dart';

class KindofServiceUsecase {
  KindofServiceUsecase({required this.dataRepository});
  final DataRepository dataRepository;

  Future<List<KindOfServiceEntity>> call() async {
    List<KindOfServiceEntity> kindOfService = await dataRepository.getKindofServiceData();
    return kindOfService;
  }
}
