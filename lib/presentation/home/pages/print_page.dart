import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:qr_flutter/qr_flutter.dart';

import '../../../domain/entities/shippment_entity.dart';

class Print extends StatefulWidget {
  const Print({required this.shipments, super.key});
  final List<ShipmentEntity> shipments;

  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  final BluetoothClassic _bluetoothClassicPlugin = BluetoothClassic();
  List<Device> _pairedDevices = [];
  final List<Device> _discoveredDevices = [];
  bool _scanning = false;
  Device? _selectedDevice;

  @override
  Future<void> initState() async {
    super.initState();
    await _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    await _bluetoothClassicPlugin.initPermissions();
    _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      if (mounted) {
        setState(() {});
      }
    });

    // await _getPairedDevices();
  }

  Future<void> _getPairedDevices() async {
    List<Device> devices = await _bluetoothClassicPlugin.getPairedDevices();
    if (mounted) {
      setState(() {
        _pairedDevices = devices;
      });
    }
  }

  Future<void> _scanDevices() async {
    if (_scanning) {
      await _bluetoothClassicPlugin.stopScan();
      if (mounted) {
        setState(() => _scanning = false);
      }
    } else {
      setState(() {
        _discoveredDevices.clear();
      });

      await _bluetoothClassicPlugin.startScan();
      _bluetoothClassicPlugin.onDeviceDiscovered().listen((event) {
        if (mounted) {
          setState(() {
            if (!_discoveredDevices.any((d) => d.address == event.address)) {
              _discoveredDevices.add(event);
            }
          });
        }
      });

      if (mounted) {
        setState(() => _scanning = true);
      }
    }
  }

  Future<void> _connectToDevice(Device device) async {
    try {
      await _bluetoothClassicPlugin.connect(
        device.address,
        '00001101-0000-1000-8000-00805F9B34FB',
      );
      setState(() {
        _selectedDevice = device;
      });
    } catch (e) {
      print('Failed to connect: $e');
    }
  }

  Future<void> _disconnectDevice() async {
    await _bluetoothClassicPlugin.disconnect();
    setState(() {
      _selectedDevice = null;
    });
  }

  Future<void> _printQR(ShipmentEntity shipment) async {
    try {
      Uint8List qrCode = await _generateQrEscPos(shipment.trackingNumber);

      print('imagebite $qrCode');
      await _bluetoothClassicPlugin.write(qrCode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR Code sent to printer')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Print failed: $e')),
      );
    }
  }

  Future<Uint8List> _generateQrEscPos(String trackingNumber) async {
    CapabilityProfile profile = await CapabilityProfile.load();
    var generator = Generator(PaperSize.mm58, profile);

    List<int> bytes = [];

    // Tambahkan teks
    bytes += generator.text(
      'Tracking Number:',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      trackingNumber,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    // Buat QR Code sebagai gambar
    ByteData? qrImage = await QrPainter(
      data: trackingNumber,
      version: QrVersions.auto,
    ).toImageData(200);

    img.Image? imgData = img.decodeImage(qrImage!.buffer.asUint8List());

    // Convert image ke format printer
    bytes += generator.image(imgData!);

    bytes += generator.feed(2);
    bytes += generator.cut();

    return Uint8List.fromList(bytes);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Print QR Code')),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.shipments.length,
                itemBuilder: (context, index) {
                  ShipmentEntity shipment = widget.shipments[index];
                  return Card(
                    child: ListTile(
                      title: Text(shipment.trackingNumber),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${shipment.customer} -> ${shipment.shipperName}',
                          ),
                          const SizedBox(height: 8),
                          QrImageView(
                            data: shipment.trackingNumber,
                            size: 100,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.print),
                        onPressed: _selectedDevice == null
                            ? null
                            : () async => _printQR(shipment),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),

            // TOMBOL SCAN
            ElevatedButton.icon(
              onPressed: _scanDevices,
              icon: Icon(_scanning ? Icons.stop : Icons.search),
              label: Text(_scanning ? 'Stop Scanning' : 'Scan Devices'),
            ),
            ElevatedButton.icon(
              onPressed: _getPairedDevices,
              icon: Icon(_scanning ? Icons.stop : Icons.search),
              label: Text(_scanning ? 'Stop Scanning' : 'paired Devices'),
            ),

            const Divider(),

            // LIST PAIRED DEVICES
            const Text(
              'Paired Devices:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _pairedDevices.isEmpty
                  ? const Center(child: Text('No Paired Bluetooth Devices'))
                  : ListView.builder(
                      itemCount: _pairedDevices.length,
                      itemBuilder: (context, index) {
                        Device device = _pairedDevices[index];
                        return ListTile(
                          title: Text(device.name ?? 'Unknown'),
                          subtitle: Text(device.address),
                          trailing: _selectedDevice?.address == device.address
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () async => _connectToDevice(device),
                        );
                      },
                    ),
            ),

            const Divider(),

            // LIST DISCOVERED DEVICES
            const Text(
              'Discovered Devices:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _discoveredDevices.isEmpty
                  ? const Center(child: Text('No New Devices Found'))
                  : ListView.builder(
                      itemCount: _discoveredDevices.length,
                      itemBuilder: (context, index) {
                        Device device = _discoveredDevices[index];
                        return ListTile(
                          title: Text(device.name ?? 'Unknown'),
                          subtitle: Text(device.address),
                          trailing: const Icon(Icons.bluetooth_searching),
                          onTap: () async => _connectToDevice(device),
                        );
                      },
                    ),
            ),

            if (_selectedDevice != null)
              ElevatedButton.icon(
                onPressed: _disconnectDevice,
                icon: const Icon(Icons.bluetooth_disabled),
                label: const Text('Disconnect'),
              ),
          ],
        ),
      );
}
