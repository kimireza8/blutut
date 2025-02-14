
import 'package:blutut_clasic/domain/entities/relation_entity.dart';

class RelationModel extends RelationEntity {
  RelationModel({
    required super.id,
    required super.code,
    required super.name,
    required super.address,
    required super.phone,
  });

  factory RelationModel.fromJson(Map<String, dynamic> json) {
    return RelationModel(
      id: json['oprcustomer_id'] ?? '',
      code: json['oprcustomer_code'] ?? '',
      name: json['oprcustomer_name'] ?? '',
      address: json['oprcustomer_address'] ?? '',
      phone: json['oprcustomer_phone'] ?? '',
    );
  }
}