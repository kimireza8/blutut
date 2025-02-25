
import '../../domain/entities/receipt/receipt_input_entity.dart';
import '../../domain/repositories/receipt_repository.dart';
import '../models/receipt/receipt_detail_model.dart';
import '../models/receipt/receipt_model.dart';
import '../remote/receipt/remote_receipt_provider.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  ReceiptRepositoryImpl({required RemoteReceiptProvider remoteReceiptProvider})
      : _remoteReceiptProvider = remoteReceiptProvider;
  final RemoteReceiptProvider _remoteReceiptProvider;

  @override
  Future<List<ReceiptModel>> getOprIncomingReceipts(
    String cookie, {
    String? searchQuery,
    int? page,
  }) async {
    List<ReceiptModel> response = await _remoteReceiptProvider
        .getOprIncomingReceipts(cookie, searchQuery: searchQuery, page: page);
    return response;
  }

  @override
  Future<ReceiptDetailModel> getDetailOprOutgoingReceipts(
    String cookie,
    String id,
  ) async {
    ReceiptDetailModel response =
        await _remoteReceiptProvider.getDetailprOutgoingReceipts(cookie, id);
    return response;
  }
  @override
  Future<void> createReceipt(String cookie, ReceiptInputEntity receipt) async {
    await _remoteReceiptProvider.createReceipt(cookie, receipt);
  }
}
