import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/receipt_bloc.dart';

class DataListPage extends StatelessWidget {
  const DataListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receipts")),
      body: BlocConsumer<ReceiptBloc, ReceiptState>(
        listener: (context, state) {
          if (state is ReceiptError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.message}")),
            );
          }
        },
        builder: (context, state) {
          if (state is ReceiptLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReceiptLoaded) {
            return ListView.builder(
              itemCount: state.receipts.length,
              itemBuilder: (context, index) {
                final receipt = state.receipts[index];
                final number =
                    receipt["oprincomingreceipt_number"] ?? "No Number";
                final date = receipt["oprincomingreceipt_date"] ?? "No Date";

                return ListTile(
                  title: Text(number),
                  subtitle: Text(date),
                );
              },
            );
          }
          return const Center(child: Text("No Data Available"));
        },
      ),
    );
  }
}
