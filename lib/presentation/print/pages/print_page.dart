import 'package:auto_route/auto_route.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../domain/entities/receipt/receipt_entity.dart';
import '../cubit/print_cubit.dart';

@RoutePage()
class PrintPage extends StatelessWidget {
  const PrintPage({required this.receipt, super.key});
  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => PrintCubit.create()..initBluetooth(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Barcode', style: TextStyle(color: Colors.white)),
            backgroundColor: const Color.fromRGBO(29, 79, 215, 1),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async => context.router.maybePop(),
                color: Colors.white,
              ),
            ],
          ),
          body: BlocBuilder<PrintCubit, PrintState>(
            builder: (context, state) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: QrImageView(
                            data: receipt.trackingNumber,
                            size: 200,
                            gapless: false,
                          ),
                        ),
                        Text(
                          receipt.trackingNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          receipt.date,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                                color: Color.fromRGBO(29, 79, 215, 1),
                              ),
                              label: const Text(
                                'Share',
                                style: TextStyle(
                                  color: Color.fromRGBO(29, 79, 215, 1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: state.selectedDevice == null
                                  ? null
                                  : () async => context
                                      .read<PrintCubit>()
                                      .printLabelTSPL(receipt.trackingNumber),
                              icon: Icon(
                                Icons.print,
                                color: state.selectedDevice == null
                                    ? Colors.grey
                                    : const Color.fromRGBO(29, 79, 215, 1),
                              ),
                              label: Text(
                                'Print Barcode',
                                style: TextStyle(
                                  color: state.selectedDevice == null
                                      ? Colors.grey
                                      : const Color.fromRGBO(29, 79, 215, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connected Printer',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  BlocBuilder<PrintCubit, PrintState>(
                    builder: (context, state) {
                      if (state is PrintConnected) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.print,
                              color: Color.fromRGBO(29, 79, 215, 1),
                            ),
                            title: Text(
                              state.device.name ?? 'Unknown',
                              style: const TextStyle(
                                color: Color.fromRGBO(29, 79, 215, 1),
                              ),
                            ),
                            subtitle: const Text('Ready'),
                          ),
                        );
                      } else {
                        return const Card(
                          child: ListTile(
                            leading: Icon(
                              Icons.print_disabled,
                              color: Color.fromRGBO(29, 79, 215, 1),
                            ),
                            title: Text(
                              'No Connected Printer',
                              style: TextStyle(
                                color: Color.fromRGBO(29, 79, 215, 1),
                              ),
                            ),
                            subtitle:
                                Text('Connecting printer to print barcode'),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available printers',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      ElevatedButton.icon(
                        onPressed: () async =>
                            context.read<PrintCubit>().getPairedDevices(),
                        icon: const Icon(
                          Icons.refresh,
                          color: Color.fromRGBO(29, 79, 215, 1),
                        ),
                        label: const Text(
                          'Refresh',
                          style: TextStyle(
                            color: Color.fromRGBO(29, 79, 215, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.pairedDevices.length,
                      itemBuilder: (context, index) {
                        Device device = state.pairedDevices[index];
                        return Card(
                          child: ListTile(
                            title: Text(device.name ?? 'Unknown'),
                            subtitle: Text(device.address),
                            trailing: ElevatedButton(
                              onPressed: () async => context
                                  .read<PrintCubit>()
                                  .connectToDevice(device),
                              child: const Text(
                                'Connect',
                                style: TextStyle(
                                  color: Color.fromRGBO(29, 79, 215, 1),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
