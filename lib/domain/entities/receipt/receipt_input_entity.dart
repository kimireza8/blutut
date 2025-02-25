class ReceiptInputEntity {
  ReceiptInputEntity({
    required this.branch,
    required this.date,
    required this.incomingDate,
    required this.customer,
    required this.customerRole,
    required this.shipperName,
    required this.shipperAddress,
    required this.shipperPhone,
    required this.consigneeName,
    required this.consigneeAddress,
    required this.consigneeCity,
    required this.consigneePhone,
    required this.receiptNumber,
    required this.passDocument,
    required this.kindOfService,
    required this.route,
    required this.totalCollies,
  });
  final String branch;
  final String date;
  final String incomingDate;
  final String customer;
  final String customerRole;
  final String shipperName;
  final String shipperAddress;
  final String shipperPhone;
  final String consigneeName;
  final String consigneeAddress;
  final String consigneeCity;
  final String consigneePhone;
  final String receiptNumber;
  final String passDocument;
  final String kindOfService;
  final String route;
  final String totalCollies;
}
