import '../../domain/entities/city_entity.dart';

class ConsigneeCityModel extends CityEntity {
  ConsigneeCityModel({
    required String id,
    required String name,
    required String type,
  }) : super(id: id, name: name, type: type);

  factory ConsigneeCityModel.fromJson(Map<String, dynamic> json) =>
      ConsigneeCityModel(
        id: json['city_id'] as String,
        name: json['city_name'] as String,
        type: json['city_citytype'] as String,
      );
}
