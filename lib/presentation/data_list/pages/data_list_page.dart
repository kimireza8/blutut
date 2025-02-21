import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/router/app_router.gr.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/shipment_entity.dart';
import '../../profile/widgets/profile_widget.dart';
import '../bloc/receipt_bloc.dart';
import '../widgets/search_bar_widget.dart';

@RoutePage()
class DataListPage extends StatefulWidget {
  const DataListPage({super.key});

  @override
  State<DataListPage> createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  String? _searchQuery;
  bool _isFetching = false;
  bool _isLastPage = false;
  Timer? _debounce;
  List<ShipmentEntity> _allReceipts = [];

  @override
  void initState() {
    super.initState();
    _fetchReceipts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _fetchReceipts({String? searchQuery, bool isRefresh = false}) {
    if (_isFetching || _isLastPage) {
      return;
    }

    if (searchQuery != null && searchQuery != _searchQuery) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _currentPage = 1;
          _isLastPage = false;
          _searchQuery = searchQuery;
          _allReceipts.clear();
        });
        _fetchReceipts();
      });
      return;
    }

    setState(() => _isFetching = true);

    context.read<ReceiptBloc>().add(
          FetchOprIncomingReceipts(
            serviceLocator<SharedPreferencesService>().getString('cookie') ??
                '',
            searchQuery: _searchQuery,
            page: _currentPage,
          ),
        );
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isFetching || _isLastPage) {
      return;
    }
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _currentPage++;
      });
      _fetchReceipts();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: BlocConsumer<ReceiptBloc, ReceiptState>(
                listener: (context, state) {
                  if (state is ReceiptError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.message}')),
                    );
                    setState(() => _isFetching = false);
                  } else if (state is ReceiptLoaded) {
                    setState(() {
                      _isFetching = false;
                      _isLastPage = state.receipts.length < 10;
                      if (_currentPage == 1) {
                        _allReceipts = state.receipts;
                      } else {
                        _allReceipts.addAll(state.receipts);
                      }
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ReceiptLoading && _currentPage == 1) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_allReceipts.isNotEmpty) {
                    return RefreshIndicator(
                      color: const Color.fromRGBO(29, 79, 215, 1),
                      onRefresh: () async {
                        setState(() {
                          _currentPage = 1;
                          _isLastPage = false;
                          _allReceipts.clear();
                        });
                        _fetchReceipts(isRefresh: true);
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        itemCount: _allReceipts.length + (_isFetching ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= _allReceipts.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          ShipmentEntity receipt = _allReceipts[index];
                          return InkWell(
                            onTap: () async {
                              await context.router.push(
                                DetailDataListRoute(shipment: receipt),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: _buildCardContent(receipt),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return const Center(child: Text('No Data Available'));
                },
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
      );

  FloatingActionButton _buildFloatingActionButton() =>
      FloatingActionButton.extended(
        onPressed: () async {
          await context.router.push(const InputRoute());
        },
        label: const Text('Add New', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromRGBO(29, 79, 215, 1),
      );

  DecoratedBox _buildAppBar() => DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(29, 79, 215, 1),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
              child: Row(
                children: [
                  const Image(image: AssetImage('assets/dahsboard_logo.png')),
                  const SizedBox(width: 8),
                  const Column(
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
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async => showProfileBottomSheet(context),
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Color.fromRGBO(29, 79, 215, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarWidget(
                onSearch: (query) {
                  _fetchReceipts(searchQuery: query);
                },
              ),
            ),
          ],
        ),
      );
  Column _buildCardContent(ShipmentEntity receipt) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (receipt.totalColi.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Total Colli : ${receipt.totalColi}',
                        style: const TextStyle(
                          color: Color.fromRGBO(
                            29,
                            79,
                            215,
                            1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  await context.router.push(
                    PrintRoute(
                      shipment: receipt,
                    ),
                  );
                },
                icon: const Icon(
                  Icons.print,
                  color: Color.fromRGBO(29, 79, 215, 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pengirim'),
                    Text(
                      receipt.shipperName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tujuan'),
                    Text(
                      receipt.branchOffice,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Penerima'),
                    Text(
                      receipt.customer,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Route'),
                    Text(
                      receipt.route,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );
}
