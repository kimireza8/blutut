import '../entities/organization_entity.dart';
import '../repositories/data_repository.dart';

class OrganizationFetchUsecase {
  final DataRepository dataRepository;

  OrganizationFetchUsecase({required this.dataRepository});

  Future<List<OrganizationEntity>> call() async {
    List<OrganizationEntity> organizations =
        await dataRepository.getOrganizationData();
    return organizations;
  }
}
