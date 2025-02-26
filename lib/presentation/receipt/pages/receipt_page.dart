import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/constant.dart';
import '../../../core/router/app_router.gr.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/receipt/receipt_entity.dart';
import '../../profile/widgets/profile_widget.dart';
import '../bloc/receipt_bloc.dart';
import '../widgets/search_bar_widget.dart';

@RoutePage()
class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  static const int _pageSize = 10;
  static const Duration _searchDebounceTime = Duration(milliseconds: 500);

  final ScrollController _scrollController = ScrollController();

  List<ReceiptEntity> _receipts = [];
  String? _searchQuery;
  int _currentPage = 1;
  bool _isFetching = false;
  bool _isLastPage = false;
  Timer? _debounce;
  late final ReceiptBloc _receiptBloc;

  @override
  void initState() {
    super.initState();
    _receiptBloc = ReceiptBloc.create();
    _fetchReceipts();
    _scrollController.addListener(_onScroll);
  }

  @override
  Future<void> dispose() async {
    await _receiptBloc.close();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _handleSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(_searchDebounceTime, () {
      setState(() {
        _resetPagination();
        _searchQuery = query;
      });
      _fetchReceipts();
    });
  }

  void _resetPagination() {
    _currentPage = 1;
    _isLastPage = false;
    _receipts.clear();
  }

  void _fetchReceipts() {
    if (_isFetching || _isLastPage) {
      return;
    }

    setState(() => _isFetching = true);

    String cookie =
        serviceLocator<SharedPreferencesService>().getString('cookie') ?? '';
    _receiptBloc.add(
      FetchOperationalIncomingReceipts(
        cookie,
        searchQuery: _searchQuery,
        page: _currentPage,
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isFetching || _isLastPage) {
      return;
    }

    double threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      setState(() => _currentPage++);
      _fetchReceipts();
    }
  }

  Future<void> _onRefresh() async {
    setState(_resetPagination);
    _fetchReceipts();
  }

  void _onReceiptTap(ReceiptEntity receipt) {
    context.router.push(ReceiptDetailRoute(receipt: receipt));
  }

  void _onPrintTap(ReceiptEntity receipt) {
    context.router.push(PrintRoute(receipt: receipt));
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _receiptBloc,
        child: Scaffold(
          body: BlocConsumer<ReceiptBloc, ReceiptState>(
            listener: _blocListener,
            builder: (context, state) {
              if (state is ReceiptLoading && _currentPage == 1) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  ReceiptAppBar(onSearch: _handleSearch),
                  Expanded(
                    child: ReceiptList(
                      receipts: _receipts,
                      isFetching: _isFetching,
                      scrollController: _scrollController,
                      onRefresh: _onRefresh,
                      onReceiptTap: _onReceiptTap,
                      onPrintTap: _onPrintTap,
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: AddNewButton(
            onPressed: () async => context.router.push(const InputRoute()),
          ),
        ),
      );

  void _blocListener(BuildContext context, ReceiptState state) {
    if (state is ReceiptError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.message}')),
      );
      setState(() => _isFetching = false);
    } else if (state is ReceiptLoaded) {
      setState(() {
        _isFetching = false;
        _isLastPage = state.receipts.length < _pageSize;
        _receipts = _currentPage == 1
            ? state.receipts
            : [..._receipts, ...state.receipts];
      });
    }
  }
}

class ReceiptAppBar extends StatelessWidget {
  const ReceiptAppBar({required this.onSearch, super.key});
  final void Function(String) onSearch;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Constant.primaryBlue,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24),
              child: AppBarContent(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarWidget(onSearch: onSearch),
            ),
          ],
        ),
      );
}

class AppBarContent extends StatelessWidget {
  const AppBarContent({super.key});

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          Image(image: AssetImage('assets/dahsboard_logo.png')),
          SizedBox(width: 8),
          CompanyInfo(),
          Spacer(),
          ProfileButton(),
        ],
      );
}

class CompanyInfo extends StatelessWidget {
  const CompanyInfo({super.key});

  @override
  Widget build(BuildContext context) => const Column(
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
            style: TextStyle(color: Colors.white),
          ),
        ],
      );
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () async => showProfileBottomSheet(context),
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Constant.primaryBlue,
          ),
        ),
      );
}

class AddNewButton extends StatelessWidget {
  const AddNewButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
        onPressed: onPressed,
        label: const Text('Add New', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Constant.primaryBlue,
      );
}

class ReceiptList extends StatelessWidget {
  const ReceiptList({
    required this.receipts,
    required this.isFetching,
    required this.scrollController,
    required this.onRefresh,
    required this.onReceiptTap,
    required this.onPrintTap,
    super.key,
  });
  final List<ReceiptEntity> receipts;
  final bool isFetching;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final void Function(ReceiptEntity) onReceiptTap;
  final void Function(ReceiptEntity) onPrintTap;

  @override
  Widget build(BuildContext context) {
    if (receipts.isEmpty) {
      return const Center(child: Text('No Data Available'));
    }

    return RefreshIndicator(
      color: Constant.primaryBlue,
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        itemCount: receipts.length + (isFetching ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= receipts.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return ReceiptCard(
            receipt: receipts[index],
            onTap: () => onReceiptTap(receipts[index]),
            onPrintTap: () => onPrintTap(receipts[index]),
          );
        },
      ),
    );
  }
}

class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    required this.receipt,
    required this.onTap,
    required this.onPrintTap,
    super.key,
  });
  final ReceiptEntity receipt;
  final VoidCallback onTap;
  final VoidCallback onPrintTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                _buildShippingInfo(),
                const SizedBox(height: 4),
                _buildReceiverInfo(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      );

  Widget _buildHeader() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              if (receipt.totalColi.isNotEmpty) _buildColliTag(),
            ],
          ),
          IconButton(
            onPressed: onPrintTap,
            icon: const Icon(
              Icons.print,
              color: Constant.primaryBlue,
            ),
          ),
        ],
      );

  Widget _buildColliTag() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Total Colli : ${receipt.totalColi}',
          style: const TextStyle(color: Constant.primaryBlue),
        ),
      );

  Widget _buildShippingInfo() => Row(
        children: [
          Expanded(
            child: InfoField(
              label: 'Pengirim',
              value: receipt.shipperName,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InfoField(
              label: 'Tujuan',
              value: receipt.branchOffice,
            ),
          ),
        ],
      );

  Widget _buildReceiverInfo() => Row(
        children: [
          Expanded(
            child: InfoField(
              label: 'Penerima',
              value: receipt.consigneeName,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InfoField(
              label: 'Route',
              value: receipt.route,
            ),
          ),
        ],
      );
}

class InfoField extends StatelessWidget {
  const InfoField({
    required this.label,
    required this.value,
    super.key,
  });
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
}

