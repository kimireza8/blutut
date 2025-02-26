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
  late final ReceiptDetailCubit _cubit;
  late final RouteInfo _routeInfo;

  @override
  void initState() {
    super.initState();
    _cubit = ReceiptDetailCubit.create();
    _routeInfo = RouteInfo.fromString(widget.receipt.route);
    _fetchReceiptDetail();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _fetchReceiptDetail() async =>
      _cubit.fetchReceiptDetail(widget.receipt.id);

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _cubit,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<ReceiptDetailCubit, ReceiptDetailState>(
            builder: (context, state) => switch (state) {
              ReceiptDetailLoading() => const LoadingView(),
              ReceiptDetailLoaded() => ReceiptDetailView(
                  detailEntity: state.detailReceiptEntity,
                  routeInfo: _routeInfo,
                  receipt: widget.receipt,
                ),
              ReceiptDetailError() => ErrorView(message: state.message),
              _ => const EmptyView(),
            },
          ),
        ),
      );
}

class RouteInfo {
  const RouteInfo({this.source, this.destination});

  factory RouteInfo.fromString(String? route) {
    if (route == null) {
      return const RouteInfo();
    }

    List<String> parts = route.split(' - ');
    return RouteInfo(
      source: parts.isNotEmpty ? parts[0] : null,
      destination: parts.length > 1 ? parts[1] : null,
    );
  }
  final String? source;
  final String? destination;
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class ErrorView extends StatelessWidget {
  const ErrorView({required this.message, super.key});

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

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

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

class ReceiptDetailView extends StatelessWidget {
  const ReceiptDetailView({
    required this.detailEntity,
    required this.routeInfo,
    required this.receipt,
    super.key,
  });

  final ReceiptDetailEntity detailEntity;
  final RouteInfo routeInfo;
  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Column(
          children: [
            const HeaderSection(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BranchOfficeCard(),
                      const SizedBox(height: 16),
                      ReceiptInfoCard(
                        detailEntity: detailEntity,
                        routeInfo: routeInfo,
                      ),
                      const SizedBox(height: 16),
                      const Spacer(),
                      ActionButtons(receipt: receipt),
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

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: Constant.primaryBlue),
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
                    'Detail Receipt',
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

class BranchOfficeCard extends StatelessWidget {
  const BranchOfficeCard({super.key});

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
                Text('Kantor Cabang', style: Constant.titleStyle),
                SizedBox(height: 4),
                Text('Surabaya', style: Constant.valueStyle),
              ],
            ),
          ],
        ),
      );
}

class ReceiptInfoCard extends StatelessWidget {
  const ReceiptInfoCard({
    required this.detailEntity,
    required this.routeInfo,
    super.key,
  });

  final ReceiptDetailEntity detailEntity;
  final RouteInfo routeInfo;

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
              const Text('Nama Relasi', style: Constant.titleStyle),
              Text(detailEntity.consigneeName,
                  style: Constant.valueStyle,),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          const Text('Tanggal', style: Constant.titleStyle),
          Text(detailEntity.date, style: Constant.valueStyle),
        ],
      );

  Widget _buildShipmentDetails() => Row(
        children: [
          Expanded(
            child: ShipperConsigneeInfo(
              shipperName: detailEntity.shipperName,
              consigneeName: detailEntity.consigneeName,
            ),
          ),
          Expanded(
            child: RouteInfoView(routeInfo: routeInfo),
          ),
        ],
      );

  Widget _buildDocumentNumbers() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('No. Resi', style: Constant.titleStyle),
          Text(detailEntity.receiptNumber, style: Constant.valueStyle),
          const SizedBox(height: 8),
          const Text('No. Surat Jalan', style: Constant.titleStyle),
          Text(detailEntity.passDocument, style: Constant.valueStyle),
        ],
      );
}

class ShipperConsigneeInfo extends StatelessWidget {
  const ShipperConsigneeInfo({
    required this.shipperName,
    required this.consigneeName,
    super.key,
  });

  final String shipperName;
  final String consigneeName;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pengirim', style: Constant.titleStyle),
          Text(shipperName, style: Constant.valueStyle),
          const SizedBox(height: 8),
          const Text('Penerima', style: Constant.titleStyle),
          Text(consigneeName, style: Constant.valueStyle),
        ],
      );
}

class RouteInfoView extends StatelessWidget {
  const RouteInfoView({required this.routeInfo, super.key});

  final RouteInfo routeInfo;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rute Pengiriman', style: Constant.titleStyle),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoutePoint(
                    icon: Icons.circle,
                    color: Colors.blue,
                    text: routeInfo.source ?? ' ',
                  ),
                  const SizedBox(height: 15),
                  RoutePoint(
                    icon: Icons.place,
                    color: Colors.red,
                    text: routeInfo.destination ?? '',
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}

class RoutePoint extends StatelessWidget {
  const RoutePoint({
    required this.icon,
    required this.color,
    required this.text,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(text, style: Constant.valueStyle),
        ],
      );
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({required this.receipt, super.key});

  final ReceiptEntity receipt;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Constant.primaryBlue),
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
              onPressed: () async =>
                  context.router.replace(PrintRoute(receipt: receipt)),
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
