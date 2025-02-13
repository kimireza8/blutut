import 'package:blutut_clasic/domain/repositories/receipt_repository.dart';

class ReceiptFetchUsecase{
  final ReceiptRepository _receiptRepository;

  ReceiptFetchUsecase({required ReceiptRepository receiptRepository}) : _receiptRepository = receiptRepository;

  Future<List<Map<String, dynamic>>> call (String token) async {
    return await _receiptRepository.getOprIncomingReceipts(token);
  }

}