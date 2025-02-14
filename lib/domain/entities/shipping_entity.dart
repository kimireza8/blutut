class Shipment {
  final String id;
  final String branchOffice;
  final String trackingNumber;
  final String date;
  final int totalColi;
  final int colliesNum;
  final int cargoNum;
  final String serviceType;
  final String route;
  final String customer;
  final String customerRole;
  final String shipperName;
  final String consigneeName;
  final String status;

  Shipment({
    required this.id,
    required this.branchOffice,
    required this.trackingNumber,
    required this.date,
    required this.totalColi,
    required this.colliesNum,
    required this.cargoNum,
    required this.serviceType,
    required this.route,
    required this.customer,
    required this.customerRole,
    required this.shipperName,
    required this.consigneeName,
    required this.status,
  });
}