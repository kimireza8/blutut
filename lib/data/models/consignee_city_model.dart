import '../../domain/entities/consignee_city_entity.dart';

class ConsigneeCityModel extends ConsigneeCityEntity {
  ConsigneeCityModel({
    required String id,
    required String name,
    required String type,
    required String code,
    required String province,
  }) : super(id: id, name: name, type: type, code: code, province: province);

  factory ConsigneeCityModel.fromJson(Map<String, dynamic> json) =>
      ConsigneeCityModel(
        id: json['city_id'] as String? ?? '',
        name: json['city_name'] as String? ?? '',
        type: json['city_citytype_citytype_shortname'] as String? ?? '',
        code: json['city_code'] as String? ?? '',
        province: json['city_province_province_name'] as String? ?? '',
      );
}
