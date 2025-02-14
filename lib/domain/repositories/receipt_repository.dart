import 'package:blutut_clasic/domain/entities/detail_shipment_entity.dart';
import 'package:blutut_clasic/domain/entities/shipping_entity.dart';

abstract class ReceiptRepository{
  Future<List<Shipment>> getOprIncomingReceipts(String cookie);
  Future<DetailShipmentEntity> getDetailprOutgoingReceipts(String cookie, String id);
}