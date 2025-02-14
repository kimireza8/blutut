// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RouteEntityAdapter extends TypeAdapter<RouteEntity> {
  @override
  final int typeId = 1;

  @override
  RouteEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RouteEntity(
      id: fields[0] as String,
      branchOfficeName: fields[1] as String,
      routeName: fields[2] as String,
      serviceType: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RouteEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.branchOfficeName)
      ..writeByte(2)
      ..write(obj.routeName)
      ..writeByte(3)
      ..write(obj.serviceType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
