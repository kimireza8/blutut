import 'package:auto_route/auto_route.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constant.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../domain/entities/receipt/receipt_detail_entity.dart';
import '../../../domain/entities/receipt/receipt_entity.dart';
import '../cubit/receipt_detail_cubit.dart';

@RoutePage()
class ReceiptDetailPage extends StatefulWidget {
  const ReceiptDetailPage({
    required this.receipt,
    super.key,
  });

  final ReceiptEntity receipt;

  @override
  State createState() => _ReceiptDetailPageState();
}

class _ReceiptDetailPageState extends State<ReceiptDetailPage> {
  String? source;
  String? destination;
  late final ReceiptDetailCubit _receiptDetailCubit;

  @override
  void initState() {
    super.initState();
    _receiptDetailCubit = ReceiptDetailCubit.create();
    fetchReceiptDetail();
    _updateRoute(widget.receipt.route);
  }

  @override
  Future<void> dispose() async {
    await _receiptDetailCubit.close();
    super.dispose();
  }

  void fetchReceiptDetail() =>
      _receiptDetailCubit.fetchReceiptDetail(widget.receipt.id);

  void _updateRoute(String? route) {
    if (route != null) {
      List<String> parts = route.split(' - ');
      source = parts.isNotEmpty ? parts[0] : '';
      destination = parts.length > 1 ? parts[1] : '';
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _receiptDetailCubit,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<ReceiptDetailCubit, ReceiptDetailState>(
            builder: _buildContent,
          ),
        ),
      );

  Widget _buildContent(BuildContext context, ReceiptDetailState state) =>
      switch (state) {
        ReceiptDetailLoading() => const _LoadingIndicator(),
        ReceiptDetailLoaded() => _ReceiptDetailContent(
            detailEntity: state.detailReceiptEntity,
            source: source,
            destination: destination,
            receipt: widget.receipt,
          ),
        ReceiptDetailError() => _ErrorView(message: state.message),
        _ => const _EmptyView(),
      };
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $message', style: const TextStyle(color: Colors.red)),
          ],
        ),
      );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('No Data Available', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
}

class _ReceiptDetailContent extends StatelessWidget {
  const _ReceiptDetailContent({
    required this.detailEntity,
    required this.source,
    required this.destination,
    required this.receipt,
  });

  final ReceiptDetailEntity detailEntity;
  final String? source;
  final String? destination;
  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _BranchOfficeCard(),
                      const SizedBox(height: 16),
                      _ReceiptInfoCard(
                        detailEntity: detailEntity,
                        source: source,
                        destination: destination,
                      ),
                      const SizedBox(height: 16),
                      const Spacer(),
                      _ActionButtons(receipt: receipt),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Constant.primaryBlue,
        ),
        padding: Constant.defaultPadding,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Preview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Tanda Terima Barang',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.article,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      );
}

class _BranchOfficeCard extends StatelessWidget {
  const _BranchOfficeCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: Constant.defaultPadding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constant.cardBorderRadius),
          border: Constant.cardBorder,
        ),
        child: const Row(
          children: [
            Icon(Icons.home, size: 32),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kantor Cabang',
                  style: Constant.titleStyle,
                ),
                SizedBox(height: 4),
                Text(
                  'Surabaya',
                  style: Constant.valueStyle,
                ),
              ],
            ),
          ],
        ),
      );
}

class _ReceiptInfoCard extends StatelessWidget {
  const _ReceiptInfoCard({
    required this.detailEntity,
    required this.source,
    required this.destination,
  });

  final ReceiptDetailEntity detailEntity;
  final String? source;
  final String? destination;

  @override
  Widget build(BuildContext context) => Container(
        padding: Constant.defaultPadding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Constant.cardBorderRadius),
          border: Constant.cardBorder,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildDateSection(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildShipmentDetails(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildDocumentNumbers(),
          ],
        ),
      );

  Widget _buildHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nama Relasi',
                style: Constant.titleStyle,
              ),
              Text(
                detailEntity.consigneeName,
                style: Constant.valueStyle,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(Constant.cardBorderRadius),
            ),
            child: Text(
              'Total Colli: ${detailEntity.totalCollies}',
              style: const TextStyle(color: Constant.primaryBlue),
            ),
          ),
        ],
      );

  Widget _buildDateSection() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tanggal',
            style: Constant.titleStyle,
          ),
          Text(
            detailEntity.date,
            style: Constant.valueStyle,
          ),
        ],
      );

  Widget _buildShipmentDetails() => Row(
        children: [
          Expanded(
            child: _ShipperConsigneeInfo(
              shipperName: detailEntity.shipperName,
              consigneeName: detailEntity.consigneeName,
            ),
          ),
          Expanded(
            child: _RouteInfo(
              source: source,
              destination: destination,
            ),
          ),
        ],
      );

  Widget _buildDocumentNumbers() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'No. Resi',
            style: Constant.titleStyle,
          ),
          Text(
            detailEntity.receiptNumber,
            style: Constant.valueStyle,
          ),
          const SizedBox(height: 8),
          const Text(
            'No. Surat Jalan',
            style: Constant.titleStyle,
          ),
          Text(
            detailEntity.passDocument,
            style: Constant.valueStyle,
          ),
        ],
      );
}

class _ShipperConsigneeInfo extends StatelessWidget {
  const _ShipperConsigneeInfo({
    required this.shipperName,
    required this.consigneeName,
  });

  final String shipperName;
  final String consigneeName;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengirim',
            style: Constant.titleStyle,
          ),
          Text(
            shipperName,
            style: Constant.valueStyle,
          ),
          const SizedBox(height: 8),
          const Text(
            'Penerima',
            style: Constant.titleStyle,
          ),
          Text(
            consigneeName,
            style: Constant.valueStyle,
          ),
        ],
      );
}

class _RouteInfo extends StatelessWidget {
  const _RouteInfo({
    required this.source,
    required this.destination,
  });

  final String? source;
  final String? destination;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rute Pengiriman',
            style: Constant.titleStyle,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 50,
                  child: DottedLine(
                    direction: Axis.vertical,
                    lineThickness: 2,
                    dashLength: 6,
                  ),
                ),
              ),
              _buildRoutePoints(),
            ],
          ),
        ],
      );

  Widget _buildRoutePoints() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildRoutePoint(
            icon: Icons.circle,
            color: Colors.blue,
            text: source ?? ' ',
          ),
          const SizedBox(height: 15),
          _buildRoutePoint(
            icon: Icons.place,
            color: Colors.red,
            text: destination ?? '',
          ),
        ],
      );

  Widget _buildRoutePoint({
    required IconData icon,
    required Color color,
    required String text,
  }) =>
      Row(
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(text, style: Constant.valueStyle),
        ],
      );
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.receipt});

  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Constant.primaryBlue,
                ),
              ),
              child: const Text(
                'Back to form',
                style: TextStyle(color: Constant.primaryBlue),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () async => context.router.replace(
                PrintRoute(receipt: receipt),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Constant.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Print'),
            ),
          ),
        ],
      );
}
