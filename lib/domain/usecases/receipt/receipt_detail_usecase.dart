import '../../entities/receipt/receipt_detail_entity.dart';
import '../../repositories/receipt_repository.dart';

class ReceiptDetailUsecase {
  ReceiptDetailUsecase(this._receiptRepository);
  final ReceiptRepository _receiptRepository;

  Future<ReceiptDetailEntity> call(String cookie, String id) async =>
      _receiptRepository.getDetailOprOutgoingReceipts(cookie, id);
}
