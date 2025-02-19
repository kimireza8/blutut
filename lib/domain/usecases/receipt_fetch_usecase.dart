import '../entities/shipment_entity.dart';
import '../repositories/receipt_repository.dart';

class ReceiptFetchUsecase {
  ReceiptFetchUsecase({required ReceiptRepository receiptRepository})
      : _receiptRepository = receiptRepository;
  final ReceiptRepository _receiptRepository;

  Future<List<ShipmentEntity>> call(String token, {String? searchQuery}) async =>
      _receiptRepository.getOprIncomingReceipts(token, searchQuery: searchQuery);
}
