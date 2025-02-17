import '../../domain/entities/route_entity.dart';

class RouteModel extends RouteEntity {
  RouteModel({
    required super.id,
    required super.branchOfficeName,
    required super.routeName,
    required super.serviceType,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
        id: json['oprroute_id'] as String? ?? '',
        branchOfficeName:
            json['oprroute_branchoffice__organization_name'] as String? ?? '',
        routeName: json['oprroute_name'] as String? ?? '',
        serviceType: json['oprroute_oprkindofservice__oprkindofservice_name']
                as String? ??
            '',
      );
}
