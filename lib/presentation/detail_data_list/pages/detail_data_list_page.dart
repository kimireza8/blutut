import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/detail_shipment_entity.dart';
import '../cubit/detail_data_list_cubit.dart';

@RoutePage()
class DetailDataListPage extends StatefulWidget {
  const DetailDataListPage({
    @PathParam('shipmentId') required this.shipmentId,
    super.key,
  });

  final String shipmentId;

  @override
  State createState() => _DetailDataListPageState();
}

class _DetailDataListPageState extends State<DetailDataListPage> {
  @override
  void initState() {
    super.initState();
    String cookie =
        serviceLocator<SharedPreferencesService>().getCookie() ?? '';
    BlocProvider.of<DetailDataListCubit>(context).onFetchDetailDataList(
      cookie,
      widget.shipmentId,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Shipment Details',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
        ),
        body: BlocBuilder<DetailDataListCubit, DetailDataListState>(
          builder: (context, state) {
            if (state is DetailDataListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DetailDataListLoaded) {
              return _buildDetailDataContent(state.detailShipmentEntity);
            } else if (state is DetailDataListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No Data Available',
                      style: TextStyle(color: Colors.grey),),
                ],
              ),
            );
          },
        ),
      );

  Widget _buildDetailDataContent(DetailShipmentEntity detailData) =>
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShipmentStatusCard(detailData),
              const SizedBox(height: 16),
              _buildShipmentInfoCard(detailData),
              const SizedBox(height: 16),
              _buildSenderCard(detailData),
              const SizedBox(height: 16),
              _buildReceiverCard(detailData),
              const SizedBox(height: 16),
              _buildDeliveryDetailsCard(detailData),
              const SizedBox(height: 16),
              _buildPaymentDetailsCard(detailData),
            ],
          ),
        ),
      );

  Widget _buildShipmentStatusCard(DetailShipmentEntity detailData) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shipment Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildStatusChip(detailData.status),
                ],
              ),
              const Divider(height: 24),
              _buildInfoRow('Shipment No', detailData.number),
              const SizedBox(height: 8),
              _buildInfoRow('Barcode', detailData.barcode),
              const SizedBox(height: 8),
              _buildInfoRow('Date', detailData.date),
              const SizedBox(height: 8),
              _buildInfoRow('Incoming Date', detailData.incomingDate),
            ],
          ),
        ),
      );

  Widget _buildShipmentInfoCard(DetailShipmentEntity detailData) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shipment Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              _buildInfoRow('Branch', detailData.branch),
              const SizedBox(height: 8),
              _buildInfoRow('Service Type', detailData.serviceType),
              const SizedBox(height: 8),
              _buildInfoRow('Total Collies', detailData.totalCollies),
              const SizedBox(height: 8),
              _buildInfoRow('Year', detailData.year),
            ],
          ),
        ),
      );

  Widget _buildSenderCard(DetailShipmentEntity detailData) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sender Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              _buildInfoRow('Name', detailData.shipperName),
              const SizedBox(height: 8),
              _buildInfoRow('Address', detailData.shipperAddress),
              const SizedBox(height: 8),
              if (detailData.shipperPhone != null)
                _buildInfoRow('Phone', detailData.shipperPhone!),
            ],
          ),
        ),
      );

  Widget _buildReceiverCard(DetailShipmentEntity detailData) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Receiver Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              _buildInfoRow('Name', detailData.consigneeName),
              const SizedBox(height: 8),
              _buildInfoRow('Address', detailData.consigneeAddress),
              const SizedBox(height: 8),
              _buildInfoRow('City', detailData.consigneeCity),
              const SizedBox(height: 8),
              _buildInfoRow('Phone', detailData.consigneePhone),
            ],
          ),
        ),
      );

  Widget _buildDeliveryDetailsCard(DetailShipmentEntity detailData) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              _buildInfoRow('Route', detailData.route),
              const SizedBox(height: 8),
              _buildInfoRow('Receive Mode', detailData.receiveMode),
              const SizedBox(height: 8),
              _buildInfoRow('Pass Document', detailData.passDocument),
            ],
          ),
        ),
      );

  Widget _buildPaymentDetailsCard(DetailShipmentEntity detailData) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              _buildInfoRow('Customer', detailData.customer),
              const SizedBox(height: 8),
              _buildInfoRow('Customer Role', detailData.customerRole),
              const SizedBox(height: 8),
              _buildInfoRow('Payment Location', detailData.paymentLocation),
              const SizedBox(height: 8),
              _buildInfoRow('Receipt Number', detailData.receiptNumber),
            ],
          ),
        ),
      );

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'delivered':
        chipColor = Colors.green;
      case 'in transit':
        chipColor = Colors.blue;
      case 'pending':
        chipColor = Colors.orange;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: chipColor,
    );
  }

  Widget _buildInfoRow(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
}
