import '../../entities/receipt/receipt_input_entity.dart';
import '../../repositories/receipt_repository.dart';

class ReceiptCreateUsecase {
  ReceiptCreateUsecase(this.receiptRepository);
  final ReceiptRepository receiptRepository;

  Future<void> call(String cookie, ReceiptInputEntity receipt) async {
    await receiptRepository.createReceipt(cookie, receipt);
  }
}
