class Shipment {
  final String branchOffice;
  final String date;
  final String relationName;
  final String sender;
  final String receiver;
  final String trackingNumber;
  final String shipmentNumber;
  final String deliveryRoute;
  final int totalColi;

  Shipment({
    required this.branchOffice,
    required this.date,
    required this.relationName,
    required this.sender,
    required this.receiver,
    required this.trackingNumber,
    required this.shipmentNumber,
    required this.deliveryRoute,
    required this.totalColi,
  });

  Map<String, dynamic> toMap() {
    return {
      'Kantor Cabang': branchOffice,
      'Tanggal': date,
      'Nama Relasi': relationName,
      'Pengirim': sender,
      'Penerima': receiver,
      'No Resi': trackingNumber,
      'No SJ': shipmentNumber,
      'Rute Pengiriman': deliveryRoute,
      'Total Coli': totalColi.toString(),
    };
  }

  String toQrData() {
    return toMap().entries.map((e) => "${e.key}: ${e.value}").join("\n");
  }
}
