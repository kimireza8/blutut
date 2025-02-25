import '../entities/receipt/receipt_detail_entity.dart';
import '../entities/receipt/receipt_entity.dart';
import '../entities/receipt/receipt_input_entity.dart';

abstract class ReceiptRepository {
  Future<List<ReceiptEntity>> getOprIncomingReceipts(
    String cookie, {
    String? searchQuery,
    int? page,
  });
  Future<ReceiptDetailEntity> getDetailOprOutgoingReceipts(
    String cookie,
    String id,
  );
  Future<void> createReceipt(String cookie, ReceiptInputEntity receipt);
}
