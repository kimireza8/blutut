import '../entities/detail_shipment_entity.dart';
import '../entities/shippment_entity.dart';

abstract class ReceiptRepository {
  Future<List<ShipmentEntity>> getOprIncomingReceipts(String cookie);
  Future<DetailShipmentEntity> getDetailprOutgoingReceipts(
    String cookie,
    String id,
  );
}
