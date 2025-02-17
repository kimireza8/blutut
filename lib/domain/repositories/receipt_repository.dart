import '../entities/detail_shipment_entity.dart';
import '../entities/shipment_entity.dart';

abstract class ReceiptRepository {
  Future<List<ShipmentEntity>> getOprIncomingReceipts(String cookie);
  Future<DetailShipmentEntity> getDetailOprOutgoingReceipts(
    String cookie,
    String id,
  );
}
