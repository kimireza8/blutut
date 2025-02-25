import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/input_data/consignee_city_entity.dart';
import '../../../domain/entities/input_data/kind_of_service_entity.dart';
import '../../../domain/entities/input_data/organization_entity.dart';
import '../../../domain/entities/input_data/relation_entity.dart';
import '../../../domain/entities/input_data/route_entity.dart';
import '../../../domain/entities/receipt/receipt_input_entity.dart';
import '../../receipt/bloc/receipt_bloc.dart';
import '../cubit/input_cubit.dart';
import 'custom_dialog_dropdown.dart';

@RoutePage()
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBranchOffice;
  DateTime? selectedDateSend;
  DateTime? selectedDateReceive;
  String? relationAs;
  String? selectedCity;
  String? selectedRoute;
  String? selectedRelation;
  String? selectedKindofService;
  final TextEditingController colliController = TextEditingController();
  final TextEditingController senderController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController receiptNumberController = TextEditingController();
  final TextEditingController deliveryNoteController = TextEditingController();
  final TextEditingController senderAddressController = TextEditingController();
  final TextEditingController receiverAddressController =
      TextEditingController();
  final TextEditingController senderHpController = TextEditingController();
  final TextEditingController receiverHpController = TextEditingController();

  @override
  void dispose() {
    colliController.dispose();
    senderController.dispose();
    receiverController.dispose();
    receiptNumberController.dispose();
    deliveryNoteController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var receipt = ReceiptInputEntity(
        branch: selectedBranchOffice ?? '',
        date: selectedDateSend != null
            ? "${selectedDateSend!.toIso8601String().split('T')[0]}T00:00:00"
            : '',
        incomingDate: selectedDateReceive != null
            ? "${selectedDateReceive!.toIso8601String().split('T')[0]}T00:00:00"
            : '',
        customer: selectedRelation ?? '',
        customerRole: relationAs ?? '',
        shipperName: senderController.text,
        shipperAddress: senderAddressController.text,
        shipperPhone: senderHpController.text,
        consigneeName: receiverController.text,
        consigneeAddress: receiverAddressController.text,
        consigneeCity: selectedCity ?? '',
        consigneePhone: receiverHpController.text,
        receiptNumber: receiptNumberController.text,
        passDocument: deliveryNoteController.text,
        kindOfService: selectedKindofService ?? '',
        route: selectedRoute ?? '',
        totalCollies: colliController.text,
      );

      context.read<ReceiptBloc>().add(
            CreateReceipt(
              serviceLocator<SharedPreferencesService>().getCookie() ?? '',
              receipt,
            ),
          );
      context.router.pop();
    }
  }

  Future<void> _selectDate(BuildContext context, bool isSendDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isSendDate) {
          selectedDateSend = picked;
        } else {
          selectedDateReceive = picked;
        }
      });
    }
  }

  void _clearFields() {
    setState(() {
      print('clear $selectedRoute');
      colliController.clear();
      senderController.clear();
      receiverController.clear();
      receiptNumberController.clear();
      deliveryNoteController.clear();

      selectedCity = null;
      selectedRoute = null;
      selectedRelation = null;
      selectedKindofService = null;
    });
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => InputCubit.create()..fetchData(),
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
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
                                Icon(
                                  Icons.article,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<InputCubit, InputState>(
                            builder: (context, state) {
                              if (state is InputLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is InputLoaded) {
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildDropdownBranchOffice(
                                          'Kantor Cabang',
                                          state.organization,
                                          selectedBranchOffice,
                                          (value) {
                                            setState(() {
                                              selectedBranchOffice = value;
                                            });
                                          },
                                        ),
                                        _buildDateField(
                                          context,
                                          'Tanggal Kirim',
                                          selectedDateSend,
                                          true,
                                        ),
                                        _buildDateField(
                                          context,
                                          'Tanggal Diterima',
                                          selectedDateReceive,
                                          false,
                                        ),
                                        _buildDropdownCustom<RelationEntity>(
                                          'Nama Relasi',
                                          state.relation,
                                          selectedRelation,
                                          (value) => setState(
                                              () => selectedRelation = value),
                                          (relation) => relation.name,
                                          (relation) => relation.id,
                                          Icons.people,
                                          context,
                                        ),
                                        _buildDropdown('Relasi Sebagai', [
                                          ['1', 'Pengirim'],
                                          ['2', 'Penerima'],
                                        ]),
                                        _buildTwoColumnField(
                                          'Pengirim',
                                          'Penerima',
                                          senderController,
                                          receiverController,
                                        ),
                                        _buildTwoColumnField(
                                          'Alamat Pengirim',
                                          'AlamatPenerima',
                                          senderController,
                                          receiverController,
                                        ),
                                        _buildTwoColumnField(
                                          'No Hp Pengirim',
                                          'No Hp Penerima',
                                          senderController,
                                          receiverController,
                                        ),
                                        _buildDropdownCustom<
                                            ConsigneeCityEntity>(
                                          'Kota Tujuan',
                                          state.city,
                                          selectedCity,
                                          (value) => setState(
                                              () => selectedCity = value),
                                          (city) => city.name,
                                          (city) => city.id,
                                          Icons.location_on,
                                          context,
                                        ),
                                        _buildTextField(
                                          'Nomor Resi',
                                          receiptNumberController,
                                        ),
                                        _buildTextField(
                                          'Nomor Surat Jalan',
                                          deliveryNoteController,
                                        ),
                                        _buildDropdownCustom<
                                            KindOfServiceEntity>(
                                          'Jenis Pelayanan',
                                          state.kindOfService,
                                          selectedKindofService,
                                          (value) => setState(() =>
                                              selectedKindofService = value),
                                          (kindOfService) => kindOfService.name,
                                          (kindOfService) => kindOfService.id,
                                          Icons.room_service,
                                          context,
                                        ),
                                        _buildDropdownCustom<RouteEntity>(
                                          'Rute Pengiriman',
                                          state.route,
                                          selectedRoute,
                                          (value) => setState(
                                              () => selectedRoute = value),
                                          (route) => route.routeName,
                                          (route) => route.id,
                                          Icons.route,
                                          context,
                                        ),
                                        _buildTextField(
                                          'Total Colli',
                                          colliController,
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            _buildTextButton(
                                              'Clear',
                                              _clearFields,
                                            ),
                                            const Spacer(),
                                            _buildOutlinedButton('Cancel',
                                                () async {
                                              await context.router.maybePop();
                                            }),
                                            const SizedBox(width: 8),
                                            _buildElevatedButton(
                                              'Next',
                                              const Color.fromRGBO(
                                                29,
                                                79,
                                                215,
                                                1,
                                              ),
                                              _submitForm,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: Text('Gagal memuat data'),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  Widget _buildDropdownCustom<T>(
    String label,
    List<T> options,
    String? selectedValue,
    Function(String?) onChanged,
    String Function(T) getLabel,
    String Function(T) getValue,
    IconData icon,
    BuildContext context,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => CustomDropdownDialog<T>(
                title: label,
                options: options,
                selectedValue: selectedValue,
                getLabel: getLabel,
                getValue: getValue,
                onChanged: onChanged,
                icon: icon,
              ),
            );
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedValue != null && options.isNotEmpty
                      ? getLabel(options
                          .firstWhere((e) => getValue(e) == selectedValue))
                      : "Pilih $label",
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
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

  Widget _buildDropdown(
    String label,
    List<List<dynamic>> options,
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
                (option) => DropdownMenuItem(
                  value: option[0],
                  child: Text(option[1].toString()),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              relationAs = value.toString();
            });
          },
          value: relationAs,
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

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    bool isSendDate,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => _selectDate(context, isSendDate),
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
                    : '${selectedDate.toLocal()}'.split(' ')[0],
              ),
            ),
          ),
        ),
      );

  Widget _buildDropdownBranchOffice(
    String label,
    List<OrganizationEntity> options,
    String? selectedValue,
    Function(String?) onChanged,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          value: selectedValue,
          items: options
              .map(
                (office) => DropdownMenuItem<String>(
                  value: office.id,
                  child: Text(office.name),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      );
}
