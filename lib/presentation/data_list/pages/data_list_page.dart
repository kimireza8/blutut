import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.gr.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/shipment_entity.dart';
import '../bloc/receipt_bloc.dart';

@RoutePage()
class DataListPage extends StatefulWidget {
  const DataListPage({super.key});

  @override
  State<DataListPage> createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ReceiptBloc>().add(
            FetchOprIncomingReceipts(
              serviceLocator<SharedPreferencesService>().getString('cookie') ??
                  '',
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(29, 79, 215, 1),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage('assets/dahsboard_logo.png'),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MATRANS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'PT Makassar Trans',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            color: Color.fromRGBO(29, 79, 215, 1),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<ReceiptBloc, ReceiptState>(
                listener: (context, state) {
                  if (state is ReceiptError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.message}')),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ReceiptLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ReceiptLoaded) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.receipts.length,
                      itemBuilder: (context, index) {
                        ShipmentEntity receipt = state.receipts[index];
                        return InkWell(
                          onTap: () {
                            context.router.push(
                                DetailDataListRoute(shipmentId: receipt.id));
                          },
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            receipt.trackingNumber,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            receipt.date,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(height: 8),
                                          if (receipt.totalColi.isNotEmpty)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'Total Colli : ${receipt.totalColi}',
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      29, 79, 215, 1),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context.router.push(Print(
                                            shipment: receipt,
                                          ));
                                        },
                                        icon: const Icon(
                                          Icons.print,
                                          color: Color.fromRGBO(29, 79, 215, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Pengirim'),
                                            Text(
                                              receipt.shipperName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Tujuan'),
                                            Text(
                                              receipt.branchOffice,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Penerima'),
                                            Text(
                                              receipt.customer,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Route'),
                                            Text(
                                              receipt.route,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text('No Data Available'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await context.router.push(const InputRoute());
          },
          label: const Text('Add New', style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.add, color: Colors.white),
          backgroundColor: const Color.fromRGBO(29, 79, 215, 1),
        ),
      );
}
