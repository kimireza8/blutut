import 'package:blutut_clasic/domain/entities/detail_shipment_entity.dart';
import 'package:blutut_clasic/domain/repositories/receipt_repository.dart';

class ReceiptDetailUsecase{
  final ReceiptRepository _receiptRepository;

  ReceiptDetailUsecase({required ReceiptRepository receiptRepository}) : _receiptRepository = receiptRepository;

  Future<DetailShipmentEntity> call (String token, String id) async {
    return await _receiptRepository.getDetailprOutgoingReceipts(token, id);
  }
}