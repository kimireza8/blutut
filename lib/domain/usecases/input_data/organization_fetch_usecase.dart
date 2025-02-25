import '../../entities/input_data/organization_entity.dart';
import '../../repositories/input_data_repository.dart';

class OrganizationFetchUsecase {
  OrganizationFetchUsecase(this.inputDataRepository);
  final InputDataRepository inputDataRepository;

  Future<List<OrganizationEntity>> call() async {
    List<OrganizationEntity> organizations =
        await inputDataRepository.getOrganizationData();
    return organizations;
  }
}
