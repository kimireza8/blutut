import 'package:blutut_clasic/presentation/home/pages/print.dart';
import 'package:blutut_clasic/presentation/home/pages/shipping_models.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Shipment> shipments = [
    Shipment(
      trackingNumber: '123456789',
      sender: 'Sender A',
      receiver: 'Receiver A',
      branchOffice: 'Jakarta',
      totalColi: 10,
      date: '2023-01-01',
      relationName: 'Company A',
      deliveryRoute: 'Jakarta - Surabaya',
      shipmentNumber: 'SJ-001',
    ),
    Shipment(
      trackingNumber: '987654321',
      sender: 'Sender B',
      receiver: 'Receiver B',
      branchOffice: 'Surabaya',
      totalColi: 20,
      date: '2023-01-02',
      relationName: 'Company B',
      deliveryRoute: 'Surabaya - Bandung',
      shipmentNumber: 'SJ-002',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengiriman'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: shipments.length,
              itemBuilder: (context, index) {
                final shipment = shipments[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      "No Resi: ${shipment.trackingNumber}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${shipment.sender} → ${shipment.receiver}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Cabang: ${shipment.branchOffice}"),
                        Text("Total Coli: ${shipment.totalColi}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Print(shipments: shipments),
                  ),
                );
              },
              child: const Text('Print QR Code'),
            ),
          ),
        ],
      ),
    );
  }
}
