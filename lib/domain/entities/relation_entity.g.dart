// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RelationEntityAdapter extends TypeAdapter<RelationEntity> {
  @override
  final int typeId = 2;

  @override
  RelationEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RelationEntity(
      id: fields[0] as String,
      code: fields[1] as String,
      name: fields[2] as String,
      address: fields[3] as String,
      phone: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RelationEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelationEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
