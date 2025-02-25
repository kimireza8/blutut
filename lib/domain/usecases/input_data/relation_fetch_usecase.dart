import '../../entities/input_data/relation_entity.dart';
import '../../repositories/input_data_repository.dart';

class RelationFetchUsecase {
  RelationFetchUsecase(this.inputDataRepository);
  final InputDataRepository inputDataRepository;

  Future<List<RelationEntity>> call() async {
    List<RelationEntity> relation =
        await inputDataRepository.getRelationData();
    return relation;
  }
}
