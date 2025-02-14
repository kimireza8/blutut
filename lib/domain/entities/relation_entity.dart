
import 'package:hive/hive.dart';
part 'relation_entity.g.dart';

@HiveType(typeId: 2)
class RelationEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String code;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String address;
  @HiveField(4)
  final String phone;

  const RelationEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.phone,
  });
}