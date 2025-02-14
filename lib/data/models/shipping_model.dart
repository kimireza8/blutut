import '../../domain/entities/shipping_entity.dart';

class ShipmentModel extends Shipment {
  ShipmentModel({
    required super.trackingNumber,
    required super.sender,
    required super.receiver,
    required super.branchOffice,
    required super.totalColi,
    required super.date,
    required super.relationName,
    required super.deliveryRoute,
    required super.shipmentNumber,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      trackingNumber: json['trackingNumber'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      receiver: json['receiver'] as String? ?? '',
      branchOffice: json['branchOffice'] as String? ?? '',
      totalColi: json['totalColi'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      relationName: json['relationName'] as String? ?? '',
      deliveryRoute: json['deliveryRoute'] as String? ?? '',
      shipmentNumber: json['shipmentNumber'] as String? ?? '',

    );
  }

}
