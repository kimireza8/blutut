import '../../domain/entities/organization_entity.dart';

class OrganizationModel extends OrganizationEntity {
  OrganizationModel({
    required super.id,
    required super.name,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      OrganizationModel(
        id: json['organization_id'] as String,
        name: json['organization_name'] as String,
      );
}
