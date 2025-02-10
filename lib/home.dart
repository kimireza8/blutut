import 'package:blutut_clasic/print.dart';
import 'package:blutut_clasic/shipping_models.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Shipment> shipments = [
    Shipment(
      trackingNumber: '123456789',
      sender: 'Sender',
      receiver: 'Receiver',
      weight: 10,
    ),
    Shipment(
      trackingNumber: '987654321',
      sender: 'Sender',
      receiver: 'Receiver',
      weight: 20,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: shipments.length,
              itemBuilder: (context, index) {
                final shipment = shipments[index];
                return ListTile(
                  title: Text(shipment.trackingNumber),
                  subtitle: Text('${shipment.sender} -> ${shipment.receiver}'),
                  trailing: Text('${shipment.weight} kg'),
                );
              },
            ),
          ),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Print(
                            shipments: shipments,
                          )));
            },
            child: const Text('print'),
          ),
        ],
      ),
    );
  }
}
