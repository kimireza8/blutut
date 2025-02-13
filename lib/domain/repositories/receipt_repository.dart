abstract class ReceiptRepository{
  Future<List<Map<String, dynamic>>> getOprIncomingReceipts(String cookie);
}