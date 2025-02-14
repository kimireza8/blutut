import 'package:blutut_clasic/domain/entities/relation_entity.dart';
import 'package:blutut_clasic/domain/entities/route_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService();

  late Box _shipmentDataBox;
  late Box<RouteEntity> _routeBox;
  late Box<RelationEntity> _relationBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _shipmentDataBox = await Hive.openBox('shipment_data_box');
    _routeBox = await Hive.openBox<RouteEntity>('route_box');
    _relationBox = await Hive.openBox<RelationEntity>('relation_box');
  }

  Box get shipmentDataBox => _shipmentDataBox;

  Future<void> setshipmentData(String key, value) async {
    await _shipmentDataBox.put(key, value);
  }

  dynamic getshipmentData(String key) => _shipmentDataBox.get(key);

  Box<RouteEntity> get routeBox => _routeBox;

  Future<void> saveRoutes(List<RouteEntity> routes) async {
    await _routeBox.clear();
    for (var route in routes) {
      await _routeBox.put(route.id, route);
    }
  }

  List<RouteEntity> getRoutes() {
    return _routeBox.values.toList();
  }

  Box<RelationEntity> get relationBox => _relationBox;

  Future<void> saveRelations(List<RelationEntity> relations) async {
    await _relationBox.clear();
    for (var relation in relations) {
      await _relationBox.put(relation.id, relation);
    }
  }
  List<RelationEntity> getRelations() {
    return _relationBox.values.toList();
  }
}
