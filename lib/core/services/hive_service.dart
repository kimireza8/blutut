import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/relation_entity.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/entities/shippment_entity.dart';

class HiveService {
  HiveService();

  Box<ShipmentEntity>? _shipmentBox;
  Box<RouteEntity>? _routeBox;
  Box<RelationEntity>? _relationBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(ShipmentEntityAdapter())
      ..registerAdapter(RouteEntityAdapter())
      ..registerAdapter(RelationEntityAdapter());
    _shipmentBox = await Hive.openBox<ShipmentEntity>('shipment_box');
    _routeBox = await Hive.openBox<RouteEntity>('route_box');
    _relationBox = await Hive.openBox<RelationEntity>('relation_box');
  }

  Box<ShipmentEntity>? get shipmentBox => _shipmentBox;

  Future<void> saveShipments(List<ShipmentEntity> shipments) async {
    for (ShipmentEntity shipment in shipments) {
      await _shipmentBox?.put(shipment.id, shipment);
    }
  }

  dynamic getShipment(String key) => _shipmentBox?.get(key);

  Box<RouteEntity>? get routeBox => _routeBox;

  Future<void> saveRoutes(List<RouteEntity> routes) async {
    for (RouteEntity route in routes) {
      await _routeBox?.put(route.id, route);
    }
  }

  List<RouteEntity>? getRoutes() => _routeBox?.values.toList();

  Box<RelationEntity>? get relationBox => _relationBox;

  Future<void> saveRelations(List<RelationEntity> relations) async {
    for (RelationEntity relation in relations) {
      await _relationBox?.put(relation.id, relation);
    }
  }

  List<RelationEntity>? getRelations() => _relationBox?.values.toList();
}
