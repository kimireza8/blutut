import 'package:hive_flutter/hive_flutter.dart';

part 'shipping_entity.g.dart';

@HiveType(typeId: 0)
class Shipment {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String branchOffice;
  @HiveField(2)
  final String trackingNumber;
  @HiveField(3)
  final String date;
  @HiveField(4)
  final int totalColi;
  @HiveField(5)
  final int colliesNum;
  @HiveField(6)
  final int cargoNum;
  @HiveField(7)
  final String serviceType;
  @HiveField(8)
  final String route;
  @HiveField(9)
  final String customer;
  @HiveField(10)
  final String customerRole;
  @HiveField(11)
  final String shipperName;
  @HiveField(12)
  final String consigneeName;
  @HiveField(13)
  final String status;

  Shipment({
    required this.id,
    required this.branchOffice,
    required this.trackingNumber,
    required this.date,
    required this.totalColi,
    required this.colliesNum,
    required this.cargoNum,
    required this.serviceType,
    required this.route,
    required this.customer,
    required this.customerRole,
    required this.shipperName,
    required this.consigneeName,
    required this.status,
  });
}