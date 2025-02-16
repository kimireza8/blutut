import '../entities/detail_shipment_entity.dart';
import '../repositories/receipt_repository.dart';

class ReceiptDetailUsecase {
  ReceiptDetailUsecase({required ReceiptRepository receiptRepository})
      : _receiptRepository = receiptRepository;
  final ReceiptRepository _receiptRepository;

  Future<DetailShipmentEntity> call(String token, String id) async =>
      _receiptRepository.getDetailprOutgoingReceipts(token, id);
}
