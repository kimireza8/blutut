import '../../../domain/entities/input_data/service_type_entity.dart';

class ServiceTypeModel extends ServiceTypeEntity {
  ServiceTypeModel({
    required super.id,
    required super.code,
    required super.name,
    required super.mode,
    required super.isActive,
  });

  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) =>
      ServiceTypeModel(
        id: json['oprkindofservice_id'] as String? ?? '',
        code: json['oprkindofservice_code'] as String? ?? '',
        name: json['oprkindofservice_name'] as String? ?? '',
        mode:
            json['oprkindofservice_oprmodetype__oprmodetype_name'] as String? ??
                '',
        isActive: json['oprkindofservice_isactive'] as String? ?? '',
      );
}
