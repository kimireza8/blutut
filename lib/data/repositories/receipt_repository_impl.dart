import 'package:blutut_clasic/data/models/shipping_model.dart';

import '../../domain/repositories/receipt_repository.dart';
import '../remote/remote_receipt_provider.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final RemoteReceiptProvider _remoteReceiptProvider;


  ReceiptRepositoryImpl({required RemoteReceiptProvider remoteReceiptProvider})
  : _remoteReceiptProvider = remoteReceiptProvider;

  @override
  Future<List<ShipmentModel>> getOprIncomingReceipts(String cookie) async {
    final response = await _remoteReceiptProvider.getOprIncomingReceipts(cookie);
    return response;
  }
}