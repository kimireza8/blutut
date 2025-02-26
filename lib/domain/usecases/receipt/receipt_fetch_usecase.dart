import '../../entities/receipt/receipt_entity.dart';
import '../../repositories/receipt_repository.dart';

class ReceiptFetchUsecase {
  ReceiptFetchUsecase(this._receiptRepository);
  final ReceiptRepository _receiptRepository;

  Future<List<ReceiptEntity>> call(
    String token, {
    String? searchQuery,
    int? page,
  }) async =>
      _receiptRepository.getOperationalIncomingReceipts(
        token,
        searchQuery: searchQuery,
        page: page,
      );
}
