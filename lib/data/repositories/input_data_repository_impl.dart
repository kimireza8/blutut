import '../../domain/repositories/input_data_repository.dart';
import '../models/input_data/consignee_city_model.dart';
import '../models/input_data/organization_model.dart';
import '../models/input_data/relation_model.dart';
import '../models/input_data/route_model.dart';
import '../models/input_data/service_type_model.dart';
import '../remote/input_data/remote_city_provider.dart';
import '../remote/input_data/remote_oprroute_provider.dart';
import '../remote/input_data/remote_organization_provider.dart';
import '../remote/input_data/remote_relation_provider.dart';
import '../remote/input_data/remote_service_type_provider.dart';

class InputDataRepositoryImpl implements InputDataRepository {
  InputDataRepositoryImpl({
    required RemoteRelationProvider remoteRelationProvider,
    required RemoteOperationalRouteProvider remoteRouteProvider,
    required RemoteOrganizationProvider remoteOrganizationProvider,
    required RemoteCityProvider remoteCityProvider,
    required RemoteServiceTypeProvider remoteServiceTypeProvider,
  })  : _remoteRelationProvider = remoteRelationProvider,
        _remoteOrganizationProvider = remoteOrganizationProvider,
        _remoteCityProvider = remoteCityProvider,
        _remoteRouteProvider = remoteRouteProvider,
        _remoteServiceTypeProvider = remoteServiceTypeProvider;
  final RemoteRelationProvider _remoteRelationProvider;
  final RemoteOperationalRouteProvider _remoteRouteProvider;
  final RemoteOrganizationProvider _remoteOrganizationProvider;
  final RemoteCityProvider _remoteCityProvider;
  final RemoteServiceTypeProvider _remoteServiceTypeProvider;

  @override
  Future<List<ConsigneeCityModel>> getConsigneeCityData() async {
    List<ConsigneeCityModel> response =
        await _remoteCityProvider.getConsigneeCities();
    return response;
  }

  @override
  Future<List<OrganizationModel>> getOrganizationData() async {
    List<OrganizationModel> response =
        await _remoteOrganizationProvider.getOperationalOrganizations();
    return response;
  }

  @override
  Future<List<RelationModel>> getRelationData() async {
    List<RelationModel> response =
        await _remoteRelationProvider.getOperationalRelations();
    return response;
  }

  @override
  Future<List<RouteModel>> getRouteData() async {
    List<RouteModel> response =
        await _remoteRouteProvider.getOperationalRoutes();
    return response;
  }

  @override
  Future<List<ServiceTypeModel>> getServiceTypeData() async {
    List<ServiceTypeModel> response =
        await _remoteServiceTypeProvider.getServiceType();
    return response;
  }
}
