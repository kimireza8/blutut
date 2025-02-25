import '../../../domain/entities/input_data/consignee_city_entity.dart';

class ConsigneeCityModel extends ConsigneeCityEntity {
  ConsigneeCityModel({
    required super.id,
    required super.name,
    required super.type,
    required super.code,
    required super.province,
  });

  factory ConsigneeCityModel.fromJson(Map<String, dynamic> json) =>
      ConsigneeCityModel(
        id: json['city_id'] as String? ?? '',
        name: json['city_name'] as String? ?? '',
        type: json['city_citytype_citytype_shortname'] as String? ?? '',
        code: json['city_code'] as String? ?? '',
        province: json['city_province_province_name'] as String? ?? '',
      );
}
