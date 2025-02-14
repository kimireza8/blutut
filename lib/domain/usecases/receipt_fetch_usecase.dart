import 'package:blutut_clasic/domain/entities/shipping_entity.dart';
import 'package:blutut_clasic/domain/repositories/receipt_repository.dart';

class ReceiptFetchUsecase{
  final ReceiptRepository _receiptRepository;

  ReceiptFetchUsecase({required ReceiptRepository receiptRepository}) : _receiptRepository = receiptRepository;

  Future<List<Shipment>> call (String token) async {
    return await _receiptRepository.getOprIncomingReceipts(token);
  }

}