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
        id: json['oprcustomer_id'] as String ?? '',
        code: json['oprcustomer_code'] as String ?? '',
        name: json['oprcustomer_name'] as String ?? '',
        address: json['oprcustomer_address'] as String ?? '',
        phone: json['oprcustomer_phone'] as String ?? '',
      );
}
