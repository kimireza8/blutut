import '../entities/city_entity.dart';
import '../entities/organization_entity.dart';
import '../entities/relation_entity.dart';
import '../entities/route_entity.dart';

abstract class DataRepository {
  Future<List<RelationEntity>> getRelationData();
  Future<List<RouteEntity>> getRouteData();
  Future<List<CityEntity>> getCityData();
  Future<List<OrganizationEntity>> getOrganizationData();
}
