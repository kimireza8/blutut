import '../entities/receipt_entity.dart';
import '../repositories/receipt_repository.dart';

class ReceiptCreateUsecase {
  final ReceiptRepository receiptRepository;

  ReceiptCreateUsecase({required this.receiptRepository});

  Future<void> call(String cookie, ReceiptEntity receipt) async {
    await receiptRepository.createReceipt(cookie,receipt);
  }
}