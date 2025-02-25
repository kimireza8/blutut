import '../entities/input_data/consignee_city_entity.dart';
import '../entities/input_data/kind_of_service_entity.dart';
import '../entities/input_data/organization_entity.dart';
import '../entities/input_data/relation_entity.dart';
import '../entities/input_data/route_entity.dart';

abstract class InputDataRepository {
  Future<List<RelationEntity>> getRelationData();
  Future<List<RouteEntity>> getRouteData();
  Future<List<ConsigneeCityEntity>> getConsigneeCityData();
  Future<List<OrganizationEntity>> getOrganizationData();
  Future<List<KindOfServiceEntity>> getKindofServiceData();
}
