import '../../domain/entities/relation_entity.dart';

class RelationModel extends RelationEntity {
  RelationModel({
    required super.id,
    required super.code,
    required super.name,
    required super.address,
    required super.phone,
  });

  factory RelationModel.fromJson(Map<String, dynamic> json) => RelationModel(
        id: json['oprcustomer_id']?.toString() ?? '',
        code: json['oprcustomer_code']?.toString() ?? '',
        name: json['oprcustomer_name']?.toString() ?? '',
        address: json['oprcustomer_address']?.toString() ?? '',
        phone: json['oprcustomer_phone']?.toString() ?? '',
      );
}
