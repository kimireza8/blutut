class ShippingEntity {
  final String trackingNumber;
  final String sender;
  final String receiver;
  final String branchOffice;
  final int totalColi;
  final String date;
  final String relationName;
  final String deliveryRoute;
  final String shipmentNumber;
  final int weight;

  ShippingEntity({
    required this.trackingNumber,
    required this.sender,
    required this.receiver,
    required this.branchOffice,
    required this.totalColi,
    required this.date,
    required this.relationName,
    required this.deliveryRoute,
    required this.shipmentNumber,
    required this.weight,
  });
}
