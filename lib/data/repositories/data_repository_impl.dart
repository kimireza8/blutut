import '../../domain/repositories/data_repository.dart';
import '../models/consignee_city_model.dart';
import '../models/organization_model.dart';
import '../models/relation_model.dart';
import '../models/route_model.dart';
import '../remote/remote_city_provider.dart';
import '../remote/remote_kind_of_service_provider.dart';
import '../remote/remote_oprroute_provider.dart';
import '../remote/remote_organization_provider.dart';
import '../remote/remote_relation_provider.dart';

class DataRepositoryImpl implements DataRepository {
  DataRepositoryImpl({
    required RemoteRelationProvider remoteRelationProvide,
    required RemoteOprRouteProvider remoteRouteProvider,
    required RemoteOrganizationProvider remoteOrganizationProvider,
    required RemoteCityProvider remoteCityProvider,
    required RemoteKindofServiceProvider remoteKindofServiceProvider,
  })  : _remoteRelationProvide = remoteRelationProvide,
        _remoteOrganizationProvider = remoteOrganizationProvider,
        _remoteCityProvider = remoteCityProvider,
        _remoteRouteProvider = remoteRouteProvider,
        _remoteKindofServiceProvider = remoteKindofServiceProvider;
  final RemoteRelationProvider _remoteRelationProvide;
  final RemoteOprRouteProvider _remoteRouteProvider;
  final RemoteOrganizationProvider _remoteOrganizationProvider;
  final RemoteCityProvider _remoteCityProvider;
  final RemoteKindofServiceProvider _remoteKindofServiceProvider;

  @override
  Future<List<ConsigneeCityModel>> getConsigneeCityData() async {
    List<ConsigneeCityModel> response =
        await _remoteCityProvider.getConsigneeCities();
    return response;
  }

  @override
  Future<List<OrganizationModel>> getOrganizationData() async {
    List<OrganizationModel> response =
        await _remoteOrganizationProvider.getOprOrganizations();
    return response;
  }

  @override
  Future<List<RelationModel>> getRelationData() async {
    List<RelationModel> response =
        await _remoteRelationProvide.getOprRelations();
    return response;
  }

  @override
  Future<List<RouteModel>> getRouteData() async {
    List<RouteModel> response = await _remoteRouteProvider.getOprRoutes();
    return response;
  }

  @override
  Future<List<KindOfServiceModel>> getKindofServiceData() async {
    List<KindOfServiceModel> response =
        await _remoteKindofServiceProvider.getKindofServices();
    return response;
  }
}
