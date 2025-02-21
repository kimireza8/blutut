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
        id: json['oprkindofservice_id'] as String? ?? '',
        code: json['oprkindofservice_code'] as String? ?? '',
        name: json['oprkindofservice_name'] as String? ?? '',
        mode:
            json['oprkindofservice_oprmodetype__oprmodetype_name'] as String? ??
                '',
        isActive: json['oprkindofservice_isactive'] as String? ?? '',
      );
}
