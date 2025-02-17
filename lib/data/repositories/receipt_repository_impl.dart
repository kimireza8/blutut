import '../../domain/repositories/receipt_repository.dart';
import '../models/detail_shipment_model.dart';
import '../models/shipment_model.dart';
import '../remote/remote_receipt_provider.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  ReceiptRepositoryImpl({required RemoteReceiptProvider remoteReceiptProvider})
      : _remoteReceiptProvider = remoteReceiptProvider;
  final RemoteReceiptProvider _remoteReceiptProvider;

  @override
  Future<List<ShipmentModel>> getOprIncomingReceipts(String cookie) async {
    List<ShipmentModel> response =
        await _remoteReceiptProvider.getOprIncomingReceipts(cookie);
    return response;
  }

  @override
  Future<DetailShipmentModel> getDetailOprOutgoingReceipts(
    String cookie,
    String id,
  ) async {
    DetailShipmentModel response =
        await _remoteReceiptProvider.getDetailprOutgoingReceipts(cookie, id);
    return response;
  }
}
