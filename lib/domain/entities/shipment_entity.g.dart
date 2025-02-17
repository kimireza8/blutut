// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShipmentEntityAdapter extends TypeAdapter<ShipmentEntity> {
  @override
  final int typeId = 0;

  @override
  ShipmentEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShipmentEntity(
      id: fields[0] as String,
      branchOffice: fields[1] as String,
      trackingNumber: fields[2] as String,
      date: fields[3] as String,
      totalColi: fields[4] as String,
      colliesNum: fields[5] as String,
      cargoNum: fields[6] as String,
      serviceType: fields[7] as String,
      route: fields[8] as String,
      customer: fields[9] as String,
      customerRole: fields[10] as String,
      shipperName: fields[11] as String,
      consigneeName: fields[12] as String,
      status: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShipmentEntity obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.branchOffice)
      ..writeByte(2)
      ..write(obj.trackingNumber)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.totalColi)
      ..writeByte(5)
      ..write(obj.colliesNum)
      ..writeByte(6)
      ..write(obj.cargoNum)
      ..writeByte(7)
      ..write(obj.serviceType)
      ..writeByte(8)
      ..write(obj.route)
      ..writeByte(9)
      ..write(obj.customer)
      ..writeByte(10)
      ..write(obj.customerRole)
      ..writeByte(11)
      ..write(obj.shipperName)
      ..writeByte(12)
      ..write(obj.consigneeName)
      ..writeByte(13)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShipmentEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
