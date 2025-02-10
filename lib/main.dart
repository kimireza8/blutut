import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BluetoothClassic _bluetoothClassicPlugin = BluetoothClassic();
  String _platformVersion = 'Unknown';
  List<Device> _pairedDevices = [];
  List<Device> _discoveredDevices = [];
  bool _scanning = false;
  int _deviceStatus = Device.disconnected;
  Uint8List _data = Uint8List(0);

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      if (mounted) {
        setState(() {
          _deviceStatus = event;
        });
      }
    });
    _bluetoothClassicPlugin.onDeviceDataReceived().listen((event) {
      if (mounted) {
        setState(() {
          _data = Uint8List.fromList([..._data, ...event]);
        });
      }
    });
  }

  Future<void> initPlatformState() async {
    try {
      final platformVersion =
          await _bluetoothClassicPlugin.getPlatformVersion() ??
              'Unknown platform version';
      if (mounted) {
        setState(() {
          _platformVersion = platformVersion;
        });
      }
    } on PlatformException {
      if (mounted) {
        setState(() {
          _platformVersion = 'Failed to get platform version.';
        });
      }
    }
  }

  Future<void> _getPairedDevices() async {
    var devices = await _bluetoothClassicPlugin.getPairedDevices();
    if (mounted) {
      setState(() {
        _pairedDevices = devices;
      });
    }
  }

  Future<void> _scanDevices() async {
    if (_scanning) {
      await _bluetoothClassicPlugin.stopScan();
      if (mounted) setState(() => _scanning = false);
    } else {
      await _bluetoothClassicPlugin.startScan();
      _bluetoothClassicPlugin.onDeviceDiscovered().listen((event) {
        if (mounted) {
          setState(() {
            if (!_discoveredDevices.contains(event)) {
              _discoveredDevices.add(event);
            }
          });
        }
      });
      if (mounted) setState(() => _scanning = true);
    }
  }

  Future<void> _connectToDevice(String address) async {
    try {
      print("Trying to connect to $address...");
      await _bluetoothClassicPlugin.connect(
          address, '00001101-0000-1000-8000-00805F9B34FB');
      print("Connected successfully");
    } catch (e) {
      print("Failed to connect: $e");
    }
  }

  Future<void> _disconnectDevice() async {
    await _bluetoothClassicPlugin.disconnect();
  }

  Future<void> _sendPing() async {
    await _bluetoothClassicPlugin.write("ping");

  }

  @override
  Widget build(BuildContext context) {
    print("data ${String.fromCharCodes(_data)}");
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Classic')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Device status: $_deviceStatus"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await _bluetoothClassicPlugin.initPermissions();
                  },
                  icon: const Icon(Icons.security),
                  label: const Text("Check Permissions"),
                ),
                ElevatedButton.icon(
                  onPressed: _getPairedDevices,
                  icon: const Icon(Icons.devices),
                  label: const Text("Get Paired Devices"),
                ),
                ElevatedButton.icon(
                  onPressed: _deviceStatus == Device.connected
                      ? _disconnectDevice
                      : null,
                  icon: const Icon(Icons.bluetooth_disabled),
                  label: const Text("Disconnect"),
                ),
                ElevatedButton.icon(
                  onPressed:
                      _deviceStatus == Device.connected ? _sendPing : null,
                  icon: const Icon(Icons.send),
                  label: const Text("Send Ping"),
                ),
                ElevatedButton.icon(
                  onPressed: _scanDevices,
                  icon: Icon(_scanning ? Icons.stop : Icons.search),
                  label: Text(_scanning ? "Stop Scan" : "Start Scan"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_pairedDevices.isNotEmpty) ...[
              const Text(
                "Paired Devices",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _pairedDevices.length,
                  itemBuilder: (context, index) {
                    final device = _pairedDevices[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(device.name ?? "Unknown Device"),
                        subtitle: Text(device.address),
                        trailing: IconButton(
                          icon: const Icon(Icons.bluetooth),
                          onPressed: () => _connectToDevice(device.address),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            if (_discoveredDevices.isNotEmpty) ...[
              const Text(
                "Discovered Devices",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _discoveredDevices.length,
                  itemBuilder: (context, index) {
                    final device = _discoveredDevices[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(device.name ?? "Unknown Device"),
                        subtitle: Text(device.address),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text("Received data: ${String.fromCharCodes(_data)}"),

          ],
        ),
      ),
    );
  }
}
