import '../../domain/repositories/data_repository.dart';
import '../models/relation_model.dart';
import '../models/route_model.dart';
import '../remote/remote_oprroute_provider.dart';
import '../remote/remote_relation_provider.dart';

class DataRepositoryImpl implements DataRepository {
  DataRepositoryImpl({
    required RemoteRelationProvider remoteRelationProvide,
    required RemoteOprRouteProvider remoteRouteProvider,
  })  : _remoteRelationProvide = remoteRelationProvide,
        _remoteRouteProvider = remoteRouteProvider;
  final RemoteRelationProvider _remoteRelationProvide;
  final RemoteOprRouteProvider _remoteRouteProvider;

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
}
