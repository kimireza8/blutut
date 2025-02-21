import '../../domain/entities/consignee_city_entity.dart';

class ConsigneeCityModel extends ConsigneeCityEntity {
  ConsigneeCityModel({
    required super.id,
    required super.name,
    required super.type,
  });

  factory ConsigneeCityModel.fromJson(Map<String, dynamic> json) =>
      ConsigneeCityModel(
        id: json['city_id'] as String,
        name: json['city_name'] as String,
        type: json['city_citytype'] as String,
      );
}
