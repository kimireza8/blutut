import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cubit/data_provider_cubit.dart';
import 'preview_input.dart';

@RoutePage()
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? selectedRoute;
  String? origin;
  String? destination;
  String? selectedRelation;
  final TextEditingController colliController = TextEditingController();
  final TextEditingController senderController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController receiptNumberController = TextEditingController();
  final TextEditingController deliveryNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DataProviderCubit>().fetchData();
  }

  @override
  void dispose() {
    colliController.dispose();
    senderController.dispose();
    receiverController.dispose();
    receiptNumberController.dispose();
    deliveryNoteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _updateRoute(String? route) {
    if (route != null) {
      List<String> parts = route.split(' - ');
      setState(() {
        selectedRoute = route;
        origin = parts.isNotEmpty ? parts[0] : '';
        destination = parts.length > 1 ? parts[1] : '';
      });
    }
  }

  void _clearFields() {
    setState(() {
      colliController.clear();
      senderController.clear();
      receiverController.clear();
      receiptNumberController.clear();
      deliveryNoteController.clear();
      selectedDate = null;
      selectedRoute = null;
      origin = null;
      destination = null;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                color: Color.fromRGBO(29, 79, 215, 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Form',
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                    Icon(
                      Icons.article,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<DataProviderCubit, DataProviderState>(
              builder: (context, state) {
                if (state is DataProviderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DataProviderLoaded) {
                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader('Kantor Cabang', 'Surabaya', Icons.home),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildRelasiDropdown(
                            'Nama Relasi',
                            state.relation.map((e) => e.name).toList(),
                          ),
                          _buildDropdown(
                              'Relasi Sebagai', ['Penerima', 'Pengirim']),
                          _buildDateField(context, 'Tanggal'),
                          _buildTextField('Total Colli', colliController),
                          _buildTwoColumnField(
                            'Pengirim',
                            'Penerima',
                            senderController,
                            receiverController,
                          ),
                          _buildRuteDropdown(state),
                          _buildRouteIcon(),
                          const SizedBox(
                            height: 10,
                          ),
                          _buildDropdown('Kota Tujuan',
                              state.city.map((e) => e.name).toList()),
                          _buildTextField(
                            'Nomor Resi',
                            receiptNumberController,
                          ),
                          _buildTextField(
                            'Nomor Surat Jalan',
                            deliveryNoteController,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _buildTextButton('Clear', _clearFields),
                              const Spacer(),
                              _buildOutlinedButton('Cancel', () {}),
                              const SizedBox(width: 8),
                              _buildElevatedButton(
                                  'Next', const Color.fromRGBO(29, 79, 215, 1),
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PreviewInputScreen(),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text('Gagal memuat data'));
                }
              },
            ),
          ],
        ),
      );

  Widget _buildRelasiDropdown(String label, List<String> options) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: options
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedRelation = value;
            });
          },
          value: selectedRelation,
        ),
      );

  Widget _buildRuteDropdown(DataProviderLoaded state) => _buildDropdownField(
        'Rute Pengiriman',
        state.route.map((e) => e.routeName).toList(),
        _updateRoute,
      );

  Widget _buildHeader(String label, String value, IconData icon) => Row(
        children: [
          Icon(icon, size: 24, color: Colors.black54),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildTextField(String label, TextEditingController controller) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      );

  Widget _buildTwoColumnField(
    String leftLabel,
    String rightLabel,
    TextEditingController leftController,
    TextEditingController rightController, {
    bool isRoute = false,
  }) =>
      Row(
        children: [
          Expanded(child: _buildTextField(leftLabel, leftController)),
          const SizedBox(
            width: 5,
          ),
          if (isRoute)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.route, color: Colors.red),
            ),
          const SizedBox(
            width: 5,
          ),
          Expanded(child: _buildTextField(rightLabel, rightController)),
        ],
      );

  Widget _buildDropdownField(
    String label,
    List<String> options,
    void Function(String?)? onChanged,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: options
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      );
  Widget _buildDropdown(
    String label,
    List<String> options,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: options
              .map(
                (option) =>
                    DropdownMenuItem(value: option, child: Text(option)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedRelation = value;
            });
          },
          value: selectedRelation,
        ),
      );

  Widget _buildTextButton(String label, VoidCallback onPressed) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: const Color.fromRGBO(29, 79, 215, 1),
        ),
        child: Text(label),
      );

  Widget _buildOutlinedButton(String label, VoidCallback onPressed) =>
      OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color.fromRGBO(29, 79, 215, 1),
          side: const BorderSide(
            color: Color.fromRGBO(29, 79, 215, 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label),
      );

  Widget _buildElevatedButton(
    String label,
    Color color,
    VoidCallback onPressed,
  ) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(color: Colors.white)),
      );

  Widget _buildDateField(BuildContext context, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              controller: TextEditingController(
                text: selectedDate == null
                    ? ''
                    : '${selectedDate!.toLocal()}'.split(' ')[0],
              ),
            ),
          ),
        ),
      );

  Widget _buildRouteIcon() => const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.my_location,
            size: 20,
            color: Colors.blue,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 200,
              child: DottedLine(
                lineThickness: 2,
                dashLength: 6,
              ),
            ),
          ),
          Icon(
            Icons.location_on,
            size: 20,
            color: Colors.red,
          ),
        ],
      );
}
