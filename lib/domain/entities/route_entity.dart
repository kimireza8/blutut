import 'package:hive/hive.dart';

part 'route_entity.g.dart';

@HiveType(typeId: 1)
class RouteEntity extends HiveObject {

  RouteEntity({
    required this.id,
    required this.branchOfficeName,
    required this.routeName,
    required this.serviceType,
  });
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String branchOfficeName;
  @HiveField(2)
  final String routeName;
  @HiveField(3)
  final String serviceType;
}
