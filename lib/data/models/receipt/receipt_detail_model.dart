import '../../../domain/entities/receipt/receipt_detail_entity.dart';

class ReceiptDetailModel extends ReceiptDetailEntity {
  ReceiptDetailModel({
    required super.id,
    required super.barcode,
    required super.branch,
    required super.consigneeAddress,
    required super.consigneeCity,
    required super.consigneeName,
    required super.consigneePhone,
    required super.date,
    required super.incomingDate,
    required super.number,
    required super.customer,
    required super.customerRole,
    required super.status,
    required super.serviceType,
    required super.receiveMode,
    required super.route,
    required super.passDocument,
    required super.paymentLocation,
    required super.receiptNumber,
    required super.shipperAddress,
    required super.shipperName,
    required super.shipperPhone,
    required super.totalCollies,
    required super.year,
  });

  factory ReceiptDetailModel.fromJson(Map<String, dynamic> json) =>
      ReceiptDetailModel(
        id: json['oprincomingreceipt_id'] as String? ?? '',
        barcode: json['oprincomingreceipt_barcode'] as String? ?? '',
        branch: json['oprincomingreceipt_branch'] as String? ?? '',
        consigneeAddress:
            json['oprincomingreceipt_consigneeaddress'] as String? ?? '',
        consigneeCity:
            json['oprincomingreceipt_consigneecity'] as String? ?? '',
        consigneeName:
            json['oprincomingreceipt_consigneename'] as String? ?? '',
        consigneePhone:
            json['oprincomingreceipt_consigneephone'] as String? ?? '',
        date: json['oprincomingreceipt_date'] as String? ?? '',
        incomingDate: json['oprincomingreceipt_incomingdate'] as String? ?? '',
        number: json['oprincomingreceipt_number'] as String? ?? '',
        customer: json['oprincomingreceipt_oprcustomer'] as String? ?? '',
        customerRole:
            json['oprincomingreceipt_oprcustomerrole'] as String? ?? '',
        status:
            json['oprincomingreceipt_oprincomingreceiptstatus'] as String? ??
                '',
        serviceType:
            json['oprincomingreceipt_oprkindofservice'] as String? ?? '',
        receiveMode: json['oprincomingreceipt_oprreceivemode'] as String? ?? '',
        route: json['oprincomingreceipt_oprroute'] as String? ?? '',
        passDocument: json['oprincomingreceipt_passdocument'] as String? ?? '',
        paymentLocation:
            json['oprincomingreceipt_paymentlocation'] as String? ?? '',
        receiptNumber:
            json['oprincomingreceipt_receiptnumber'] as String? ?? '',
        shipperAddress:
            json['oprincomingreceipt_shipperaddress'] as String? ?? '',
        shipperName: json['oprincomingreceipt_shippername'] as String? ?? '',
        shipperPhone: json['oprincomingreceipt_shipperphone'] as String? ?? '',
        totalCollies: json['oprincomingreceipt_totalcollies'] as String? ?? '',
        year: json['oprincomingreceipt_year'] as String? ?? '',
      );
}
