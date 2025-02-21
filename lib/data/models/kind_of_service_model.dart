import '../../domain/entities/kind_of_service_entity.dart';

class KindOfServiceModel extends KindOfServiceEntity {
  KindOfServiceModel({
    required super.id,
    required super.code,
    required super.name,
    required super.mode,
    required super.isActive,
  });

  factory KindOfServiceModel.fromJson(Map<String, dynamic> json) =>
      KindOfServiceModel(
        id: json['id'] as String? ?? '',
        code: json['code'] as String? ?? '',
        name: json['name'] as String? ?? '',
        mode: json['mode'] as String? ?? '',
        isActive: json['isActive'] as bool? ?? false,
      );
}
