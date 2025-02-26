import '../../data/models/receipt/receipt_detail_model.dart';
import '../../data/models/receipt/receipt_input_model.dart';
import '../entities/receipt/receipt_detail_entity.dart';
import '../entities/receipt/receipt_entity.dart';

abstract class ReceiptRepository {
  Future<List<ReceiptEntity>> getOperationalIncomingReceipts(
    String cookie, {
    String? searchQuery,
    int? page,
  });
  Future<ReceiptDetailEntity> getDetailOperationalOutgoingReceipts(
    String cookie,
    String id,
  );
  Future<void> createReceipt(String cookie, ReceiptInputModel receipt);
  Future<void> updateReceipt(
    String cookie,
    ReceiptDetailModel receipt,
  );

}
