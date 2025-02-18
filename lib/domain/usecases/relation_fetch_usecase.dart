import '../entities/relation_entity.dart';
import '../repositories/data_repository.dart';

class RelationFetchUsecase {
  final DataRepository _dataRepository;

  RelationFetchUsecase({required DataRepository dataRepository})
      : _dataRepository = dataRepository;

  Future<List<RelationEntity>> call() async {
    List<RelationEntity> relation = await _dataRepository.getRelationData();
    return relation;
  }
}
