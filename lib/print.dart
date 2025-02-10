import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'shipping_models.dart';

class Print extends StatefulWidget {
  final List<Shipment> shipments;
  const Print({super.key, required this.shipments});

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  final _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _devices = [];

  @override
  void initState() {
    super.initState();
    _initPrint();
  }

  Future<void> _initPrint() async {
    _bluetoothClassicPlugin.startScan();

    try {
      List<Device> pairedDevices =
          await _bluetoothClassicPlugin.getPairedDevices();
      setState(() {
        _devices = pairedDevices;
      });
    } catch (e) {
      debugPrint("Error fetching paired devices: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.shipments.length,
              itemBuilder: (context, index) {
                final shipment = widget.shipments[index];
                return ListTile(
                  title: Text(shipment.trackingNumber),
                  subtitle: Text('${shipment.sender} -> ${shipment.receiver}'),
                  trailing: Text('${shipment.weight} kg'),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: _devices.isEmpty
                ? const Center(child: Text("No Bluetooth printers found"))
                : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      return ListTile(
                        title: Text(device.name ?? 'Unknown'),
                        subtitle: Text(device.address),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: ${device.name}')),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
