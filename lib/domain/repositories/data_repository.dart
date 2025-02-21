import '../entities/consignee_city_entity.dart';
import '../entities/kind_of_service_entity.dart';
import '../entities/organization_entity.dart';
import '../entities/relation_entity.dart';
import '../entities/route_entity.dart';

abstract class DataRepository {
  Future<List<RelationEntity>> getRelationData();
  Future<List<RouteEntity>> getRouteData();
  Future<List<ConsigneeCityEntity>> getConsigneeCityData();
  Future<List<OrganizationEntity>> getOrganizationData();
  Future<List<KindOfServiceEntity>> getKindofServiceData();
}
