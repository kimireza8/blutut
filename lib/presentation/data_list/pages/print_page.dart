import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../domain/entities/shipment_entity.dart';
import '../../home/print_cubit/print_cubit.dart';

@RoutePage()
class Print extends StatelessWidget {
  const Print({required this.shipment, super.key});
  final ShipmentEntity shipment;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Print QR Code')),
        body: BlocBuilder<PrintCubit, PrintState>(
          builder: (context, state) => Column(
            children: [
              Expanded(
                child: Card(
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
                      onPressed: state.selectedDevice == null
                          ? null
                          : () async {
                              await context
                                  .read<PrintCubit>()
                                  .printQR(shipment);
                            },
                    ),
                  ),
                ),
              ),
              const Divider(),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<PrintCubit>().scanDevices();
                },
                icon: Icon(state.scanning ? Icons.stop : Icons.search),
                label: Text(state.scanning ? 'Stop Scanning' : 'Scan Devices'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<PrintCubit>().getPairedDevices();
                },
                icon: const Icon(Icons.search),
                label: const Text('Paired Devices'),
              ),
              const Divider(),
              const Text(
                'Paired Devices:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: state.pairedDevices.isEmpty
                    ? const Center(child: Text('No Paired Bluetooth Devices'))
                    : ListView.builder(
                        itemCount: state.pairedDevices.length,
                        itemBuilder: (context, index) {
                          Device device = state.pairedDevices[index];
                          return ListTile(
                            title: Text(device.name ?? 'Unknown'),
                            subtitle: Text(device.address),
                            trailing: state.selectedDevice?.address ==
                                    device.address
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () async {
                              await context
                                  .read<PrintCubit>()
                                  .connectToDevice(device);
                            },
                          );
                        },
                      ),
              ),
              const Divider(),
              const Text(
                'Discovered Devices:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: state.discoveredDevices.isEmpty
                    ? const Center(child: Text('No New Devices Found'))
                    : ListView.builder(
                        itemCount: state.discoveredDevices.length,
                        itemBuilder: (context, index) {
                          Device device = state.discoveredDevices[index];
                          return ListTile(
                            title: Text(device.name ?? 'Unknown'),
                            subtitle: Text(device.address),
                            trailing: const Icon(Icons.bluetooth_searching),
                            onTap: () async {
                              await context
                                  .read<PrintCubit>()
                                  .connectToDevice(device);
                            },
                          );
                        },
                      ),
              ),
              if (state.selectedDevice != null)
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<PrintCubit>().disconnectDevice();
                  },
                  icon: const Icon(Icons.bluetooth_disabled),
                  label: const Text('Disconnect'),
                ),
              if (state is PrintSuccess) SnackBar(content: Text(state.message)),
              if (state is PrintError) SnackBar(content: Text(state.error)),
            ],
          ),
        ),
      );
}
