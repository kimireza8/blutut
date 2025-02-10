class Shipment {
  final String trackingNumber;
  final String sender;
  final String receiver;
  final double weight;

  Shipment({
    required this.trackingNumber,
    required this.sender,
    required this.receiver,
    required this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      'trackingNumber': trackingNumber,
      'sender': sender,
      'receiver': receiver,
      'weight': weight,
    };
  }
}
