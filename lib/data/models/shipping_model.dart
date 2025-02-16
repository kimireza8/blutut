import '../../domain/entities/shippment_entity.dart';

class ShipmentModel extends ShipmentEntity {
  ShipmentModel({
    required super.id,
    required super.branchOffice,
    required super.trackingNumber,
    required super.date,
    required super.totalColi,
    required super.colliesNum,
    required super.cargoNum,
    required super.serviceType,
    required super.route,
    required super.customer,
    required super.customerRole,
    required super.shipperName,
    required super.consigneeName,
    required super.status,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) => ShipmentModel(
        id: json['oprincomingreceipt_id'] as String? ?? '',
        branchOffice:
            json['oprincomingreceipt_branch__organization_name'] as String? ??
                '',
        trackingNumber: json['oprincomingreceipt_number'] as String? ?? '',
        date: json['oprincomingreceipt_date'] as String? ?? '',
        totalColi: json['oprincomingreceipt_totalcollies'] as String? ?? '0',
        colliesNum: json['oprincomingreceipt_colliesnum'] as String? ?? '0',
        cargoNum: json['oprincomingreceipt_cargonum'] as String? ?? '0',
        serviceType:
            json['oprincomingreceipt_oprkindofservice__oprkindofservice_name']
                    as String? ??
                '',
        route:
            json['oprincomingreceipt_oprroute__oprroute_name'] as String? ?? '',
        customer: json['oprincomingreceipt_oprcustomer__oprcustomer_name']
                as String? ??
            '',
        customerRole:
            json['oprincomingreceipt_oprcustomerrole__oprcustomerrole_name']
                    as String? ??
                '',
        shipperName: json['oprincomingreceipt_shippername'] as String? ?? '',
        consigneeName:
            json['oprincomingreceipt_consigneename'] as String? ?? '',
        status:
            json['oprincomingreceipt_oprincomingreceiptstatus__oprincomingreceiptstatus_name']
                    as String? ??
                '',
      );
}
