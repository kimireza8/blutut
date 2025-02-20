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
  int _currentPage = 1;
  String? _searchQuery;
  bool _isLastPage = false; // Track if current page is the last page
// Track the last valid page that had data

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchReceipts);
  }

  void _fetchReceipts({String? searchQuery}) {
    // Only reset page when search query changes
    if (searchQuery != null && searchQuery != _searchQuery) {
      setState(() {
        _currentPage = 1; // Reset page to 1 for new searches
// Reset last valid page
        _isLastPage = false; // Reset assumption about pagination
      });
    }

    // Update the current search query if provided
    if (searchQuery != null) {
      _searchQuery = searchQuery;
    }

    context.read<ReceiptBloc>().add(
          FetchOprIncomingReceipts(
            serviceLocator<SharedPreferencesService>().getString('cookie') ??
                '',
            searchQuery: _searchQuery,
            page: _currentPage,
          ),
        );
  }

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _isLastPage =
            false; // We know there's at least one more page (the one we just came from)
      });
      _fetchReceipts();
    }
  }

  void _nextPage() {
    setState(() {
      _currentPage++;
    });
    _fetchReceipts();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: BlocConsumer<ReceiptBloc, ReceiptState>(
                // Modify your BlocConsumer's listener to not automatically navigate back
                listener: (context, state) {
                  if (state is ReceiptError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.message}')),
                    );

                    // If we get an error on a page beyond page 1, it might mean we've gone too far
                    if (_currentPage > 1 &&
                        state.message.contains('No data found')) {
                      setState(() {
                        // Mark as last page, but don't auto-navigate back
                        _isLastPage = true;
                      });
                    }
                  } else if (state is ReceiptLoaded) {
                    // If we got data, this is a valid page - remember it
                    if (state.receipts.isNotEmpty) {
                      setState(() {
                        _isLastPage = false;
                      });
                    } else {
                      // We got an empty list - mark as last page but don't auto-navigate
                      setState(() {
                        _isLastPage = true;
                      });
                    }
                  }
                },
                builder: (context, state) {
                  if (state is ReceiptLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ReceiptLoaded) {
                    if (state.receipts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No data found'),
                            if (_searchQuery != null &&
                                _searchQuery!.isNotEmpty)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = null;
                                    _currentPage = 1;
                                    _isLastPage = false;
                                  });
                                  _fetchReceipts();
                                },
                                child: const Text('Clear Search'),
                              ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: const Color.fromRGBO(29, 79, 215, 1),
                      onRefresh: () async {
                        _fetchReceipts();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                        itemCount: state.receipts.length,
                        itemBuilder: (context, index) {
                          ShipmentEntity receipt = state.receipts[index];
                          return InkWell(
                            onTap: () async {
                              await context.router.push(
                                DetailDataListRoute(shipmentId: receipt.id),
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
            _buildPagination(),
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
                  const Image(
                    image: AssetImage('assets/dahsboard_logo.png'),
                  ),
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
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

  Padding _buildPagination() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _currentPage > 1 ? _previousPage : null,
              child: const Text('Previous'),
            ),
            Text(
              _searchQuery != null && _searchQuery!.isNotEmpty
                  ? 'Page $_currentPage (Filtered)'
                  : 'Page $_currentPage',
            ),
            ElevatedButton(
              // Always enable Next button unless we've confirmed it's the last page
              onPressed: _isLastPage ? null : _nextPage,
              child: const Text('Next'),
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
