import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/input_data/relation_entity.dart';
import '../../domain/entities/input_data/route_entity.dart';
import '../../domain/entities/receipt/receipt_entity.dart';

class HiveService {
  HiveService();

  Box<ReceiptEntity>? _receiptBox;
  Box<RouteEntity>? _routeBox;
  Box<RelationEntity>? _relationBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(ReceiptEntityAdapter())
      ..registerAdapter(RouteEntityAdapter())
      ..registerAdapter(RelationEntityAdapter());
    _receiptBox = await Hive.openBox<ReceiptEntity>('receipt_box');
    _routeBox = await Hive.openBox<RouteEntity>('route_box');
    _relationBox = await Hive.openBox<RelationEntity>('relation_box');
  }

  Box<ReceiptEntity>? get receiptBox => _receiptBox;

  Future<void> saveReceipts(List<ReceiptEntity> receipts) async {
    for (ReceiptEntity receipt in receipts) {
      await _receiptBox?.put(receipt.id, receipt);
    }
  }

  dynamic getReceipt(String key) => _receiptBox?.get(key);

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
