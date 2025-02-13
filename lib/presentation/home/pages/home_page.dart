import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:blutut_clasic/presentation/home/pages/print_page.dart';

import '../../../data/models/shipping_model.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Shipment> shipments = [
    Shipment(
      trackingNumber: '123456789',
      sender: 'Sender A',
      receiver: 'Receiver A',
      branchOffice: 'Bandung',
      totalColi: 10,
      date: '2023-01-01',
      relationName: 'Company A',
      deliveryRoute: 'Bandung - Surabaya',
      shipmentNumber: 'SJ-001',
      weight: 10,
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
      weight: 20,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengiriman',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: shipments.length,
              itemBuilder: (context, index) {
                final shipment = shipments[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("No Resi: ${shipment.trackingNumber}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Chip(
                              label: Text(shipment.branchOffice,
                                  style: const TextStyle(color: Colors.white)),
                              backgroundColor: Colors.blueAccent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                            "Pengirim: ${shipment.sender} → ${shipment.receiver}",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 4),
                        Text("Rute: ${shipment.deliveryRoute}",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Coli: ${shipment.totalColi}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Text("Tanggal: ${shipment.date}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Print(shipments: shipments),
                  ));
                },
                child: const Text('Print QR Code',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
