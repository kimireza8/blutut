import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/status_color_util.dart';
import '../../../domain/entities/shippment_entity.dart';
import '../../profile/pages/profile_page.dart';
import '../bloc/receipt_bloc.dart';

@RoutePage()
class DataListPage extends StatefulWidget {
  const DataListPage({super.key});

  @override
  State<DataListPage> createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Makassar Trans'),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Receipts'),
                Tab(text: 'Profile'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              buildReceiptsTab(),
              const ProfilePage(),
            ],
          ),
        ),
      );

  Widget buildReceiptsTab() => BlocConsumer<ReceiptBloc, ReceiptState>(
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
              padding: const EdgeInsets.all(8),
              itemCount: state.receipts.length,
              itemBuilder: (context, index) {
                ShipmentEntity receipt = state.receipts[index];
                String number = receipt.trackingNumber;
                String date = receipt.date;
                String shipper = receipt.shipperName;
                String consignee = receipt.consigneeName;
                String status = receipt.status;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.blueAccent,
                      size: 36,
                    ),
                    title: Text(
                      'No: $number',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal: $date'),
                        Text('Pengirim: $shipper'),
                        Text('Penerima: $consignee'),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: StatusColorUtil.getStatusColor(
                              status,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No Data Available'));
        },
      );
}
