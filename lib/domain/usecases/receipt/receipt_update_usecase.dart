import '../../../data/models/receipt/receipt_detail_model.dart';
import '../../entities/receipt/receipt_detail_entity.dart';
import '../../repositories/receipt_repository.dart';

class ReceiptUpdateUsecase {
  ReceiptUpdateUsecase(this.receiptRepository);
  final ReceiptRepository receiptRepository;

  Future<void> call(String cookie, ReceiptDetailEntity receipt) async {
    await receiptRepository.updateReceipt(
      cookie,
      ReceiptDetailModel(
        id: receipt.id,
        barcode: receipt.barcode,
        branch: receipt.branch,
        consigneeAddress: receipt.consigneeAddress,
        consigneeCity: receipt.consigneeCity,
        consigneeName: receipt.consigneeName,
        consigneePhone: receipt.consigneePhone,
        date: receipt.date,
        incomingDate: receipt.incomingDate,
        month: receipt.month,
        number: receipt.number,
        customer: receipt.customer,
        customerRole: receipt.customerRole,
        status: receipt.status,
        serviceType: receipt.serviceType,
        receiveMode: receipt.receiveMode,
        route: receipt.route,
        passDocument: receipt.passDocument,
        paymentLocation: receipt.paymentLocation,
        receiptNumber: receipt.receiptNumber,
        shipperAddress: receipt.shipperAddress,
        shipperName: receipt.shipperName,
        totalCollies: receipt.totalCollies,
        year: receipt.year,
      ),
    );
  }
}
