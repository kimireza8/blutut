import 'package:blutut_clasic/domain/entities/shipping_entity.dart';

abstract class ReceiptRepository{
  Future<List<Shipment>> getOprIncomingReceipts(String cookie);
}