class ReceiptDetailEntity {
  ReceiptDetailEntity({
    required this.id,
    required this.barcode,
    required this.branch,
    required this.consigneeAddress,
    required this.consigneeCity,
    required this.consigneeName,
    required this.consigneePhone,
    required this.date,
    required this.incomingDate,
    required this.month,
    required this.number,
    required this.customer,
    required this.customerRole,
    required this.status,
    required this.serviceType,
    required this.receiveMode,
    required this.route,
    required this.passDocument,
    required this.paymentLocation,
    required this.receiptNumber,
    required this.shipperAddress,
    required this.shipperName,
    required this.totalCollies,
    required this.year,
    this.shipperPhone,
    this.contents,
    this.termsOfPayment,
    this.notifyPartyAddress,
    this.notifyPartyName,
    this.notifyPartyPhone,
  });

  final String id;
  final String barcode;
  final String branch;
  final String consigneeAddress;
  final String consigneeCity;
  final String consigneeName;
  final String consigneePhone;
  final String date;
  final String incomingDate;
  final String month;
  final String number;
  final String customer;
  final String customerRole;
  final String status;
  final String serviceType;
  final String receiveMode;
  final String route;
  final String passDocument;
  final String paymentLocation;
  final String receiptNumber;
  final String shipperAddress;
  final String shipperName;
  final String? shipperPhone;
  final String totalCollies;
  final String year;
  final String? contents;
  final String? termsOfPayment;
  final String? notifyPartyAddress;
  final String? notifyPartyName;
  final String? notifyPartyPhone;
}
