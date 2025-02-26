import '../../../data/models/receipt/receipt_input_model.dart';
import '../../entities/receipt/receipt_input_entity.dart';
import '../../repositories/receipt_repository.dart';

class ReceiptCreateUsecase {
  ReceiptCreateUsecase(this.receiptRepository);
  final ReceiptRepository receiptRepository;

  Future<void> call(String cookie, ReceiptInputEntity receipt) async {
    await receiptRepository.createReceipt(
      cookie,
      ReceiptInputModel(
        branch: receipt.branch,
        date: receipt.date,
        incomingDate: receipt.incomingDate,
        customer: receipt.customer,
        customerRole: receipt.customerRole,
        shipperName: receipt.shipperName,
        shipperAddress: receipt.shipperAddress,
        shipperPhone: receipt.shipperPhone,
        consigneeName: receipt.consigneeName,
        consigneeAddress: receipt.consigneeAddress,
        consigneeCity: receipt.consigneeCity,
        consigneePhone: receipt.consigneePhone,
        receiptNumber: receipt.receiptNumber,
        passDocument: receipt.passDocument,
        serviceType: receipt.serviceType,
        route: receipt.route,
        totalCollies: receipt.totalCollies,
      ),
    );
  }
}
