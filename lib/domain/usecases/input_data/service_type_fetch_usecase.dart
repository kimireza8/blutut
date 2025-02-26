import '../../entities/input_data/service_type_entity.dart';
import '../../repositories/input_data_repository.dart';

class ServiceTypeFetchUsecase {
  ServiceTypeFetchUsecase(this.inputDataRepository);
  final InputDataRepository inputDataRepository;

  Future<List<ServiceTypeEntity>> call() async {
    List<ServiceTypeEntity> serviceType =
        await inputDataRepository.getServiceTypeData();
    return serviceType;
  }
}
