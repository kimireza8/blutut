import '../../../domain/entities/receipt/receipt_input_entity.dart';

class ReceiptInputModel extends ReceiptInputEntity {
  ReceiptInputModel({
    required super.branch,
    required super.date,
    required super.incomingDate,
    required super.customer,
    required super.customerRole,
    required super.shipperName,
    required super.shipperAddress,
    required super.shipperPhone,
    required super.consigneeName,
    required super.consigneeAddress,
    required super.consigneeCity,
    required super.consigneePhone,
    required super.receiptNumber,
    required super.passDocument,
    required super.kindOfService,
    required super.route,
    required super.totalCollies,
  });
  factory ReceiptInputModel.fromJson(Map<String, dynamic> json) =>
      ReceiptInputModel(
        branch: json['oprincomingreceipt_branch'] as String? ?? '',
        date: json['oprincomingreceipt_date'] as String? ?? '',
        incomingDate: json['oprincomingreceipt_incomingdate'] as String? ?? '',
        customer: json['oprincomingreceipt_oprcustomer'] as String? ?? '',
        customerRole:
            json['oprincomingreceipt_oprcustomerrole'] as String? ?? '',
        shipperName: json['oprincomingreceipt_shippername'] as String? ?? '',
        shipperAddress:
            json['oprincomingreceipt_shipperaddress'] as String? ?? '',
        shipperPhone: json['oprincomingreceipt_shipperphone'] as String? ?? '',
        consigneeName:
            json['oprincomingreceipt_consigneename'] as String? ?? '',
        consigneeAddress:
            json['oprincomingreceipt_consigneeaddress'] as String? ?? '',
        consigneeCity:
            json['oprincomingreceipt_consigneecity'] as String? ?? '',
        consigneePhone:
            json['oprincomingreceipt_consigneephone'] as String? ?? '',
        receiptNumber:
            json['oprincomingreceipt_receiptnumber'] as String? ?? '',
        passDocument: json['oprincomingreceipt_passdocument'] as String? ?? '',
        kindOfService:
            json['oprincomingreceipt_oprkindofservice'] as String? ?? '',
        route: json['oprincomingreceipt_oprroute'] as String? ?? '',
        totalCollies: json['oprincomingreceipt_totalcollies'] as String? ?? '',
      );
}
