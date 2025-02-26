import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../../domain/entities/input_data/consignee_city_entity.dart';
import '../../../domain/entities/input_data/organization_entity.dart';
import '../../../domain/entities/input_data/relation_entity.dart';
import '../../../domain/entities/input_data/route_entity.dart';
import '../../../domain/entities/input_data/service_type_entity.dart';
import '../../../domain/entities/receipt/receipt_input_entity.dart';
import '../../receipt/bloc/receipt_bloc.dart';
import '../cubit/input_cubit.dart';
import 'custom_dialog_dropdown.dart';

@RoutePage()
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final _formControllers = ReceiptFormControllers();
  final _formValues = ReceiptFormValues();

  late final InputCubit _inputCubit;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _inputCubit = InputCubit.create();
    _inputCubit.fetchData();
  }

  @override
  void dispose() {
    _formControllers.dispose();
    _inputCubit.close();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, DateType dateType) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        if (dateType == DateType.send) {
          _formValues.dateSend = picked;
        } else {
          _formValues.dateReceive = picked;
        }
      });
    }
  }

  void _clearFields() {
    setState(() {
      _formControllers.clear();
      _formValues.clearSelections();
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      var receiptInput = ReceiptInputEntity(
        branch: _formValues.branchOffice ?? '',
        date: _formatDate(_formValues.dateSend),
        incomingDate: _formatDate(_formValues.dateReceive),
        customer: _formValues.relation ?? '',
        customerRole: _formValues.relationAs ?? '',
        shipperName: _formControllers.sender.text,
        shipperAddress: _formControllers.senderAddress.text,
        shipperPhone: _formControllers.senderHp.text,
        consigneeName: _formControllers.receiver.text,
        consigneeAddress: _formControllers.receiverAddress.text,
        consigneeCity: _formValues.city ?? '',
        consigneePhone: _formControllers.receiverHp.text,
        receiptNumber: _formControllers.receiptNumber.text,
        passDocument: _formControllers.deliveryNote.text,
        serviceType: _formValues.serviceType ?? '',
        route: _formValues.route ?? '',
        totalCollies: _formControllers.colli.text,
      );

      String cookie =
          serviceLocator<SharedPreferencesService>().getCookie() ?? '';
      context.read<ReceiptBloc>().add(CreateReceipt(cookie, receiptInput));
      await context.router.maybePop();
    }
  }

  String _formatDate(DateTime? date) =>
      date != null ? "${date.toIso8601String().split('T')[0]}T00:00:00" : '';

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _inputCubit,
        child: Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const ReceiptHeaderSection(),
                        Expanded(
                          child: BlocBuilder<InputCubit, InputState>(
                            builder: (context, state) {
                              if (state is InputLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is InputLoaded) {
                                return _buildForm(state);
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

  Widget _buildForm(InputLoaded state) => Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdownBranchOffice(
                'Kantor Cabang',
                state.organization,
                _formValues.branchOffice,
                (value) => setState(() => _formValues.branchOffice = value),
              ),
              _buildDateField(
                context,
                'Tanggal Kirim',
                _formValues.dateSend,
                DateType.send,
              ),
              _buildDateField(
                context,
                'Tanggal Diterima',
                _formValues.dateReceive,
                DateType.receive,
              ),
              _buildDropdownCustom<RelationEntity>(
                'Nama Relasi',
                state.relation,
                _formValues.relation,
                (value) => setState(() => _formValues.relation = value),
                (relation) => relation.name,
                (relation) => relation.id,
                Icons.people,
                context,
              ),
              _buildDropdown(
                'Relasi Sebagai',
                [
                  ['1', 'Pengirim'],
                  ['2', 'Penerima'],
                ],
                _formValues.relationAs,
                (value) => setState(() => _formValues.relationAs = value),
              ),
              _buildTwoColumnField(
                'Pengirim',
                'Penerima',
                _formControllers.sender,
                _formControllers.receiver,
              ),
              _buildTwoColumnField(
                'Alamat Pengirim',
                'Alamat Penerima',
                _formControllers.senderAddress,
                _formControllers.receiverAddress,
              ),
              _buildTwoColumnField(
                'No Hp Pengirim',
                'No Hp Penerima',
                _formControllers.senderHp,
                _formControllers.receiverHp,
              ),
              _buildDropdownCustom<ConsigneeCityEntity>(
                'Kota Tujuan',
                state.city,
                _formValues.city,
                (value) => setState(() => _formValues.city = value),
                (city) => city.name,
                (city) => city.id,
                Icons.location_on,
                context,
              ),
              _buildTextField(
                'Nomor Resi',
                _formControllers.receiptNumber,
              ),
              _buildTextField(
                'Nomor Surat Jalan',
                _formControllers.deliveryNote,
              ),
              _buildDropdownCustom<ServiceTypeEntity>(
                'Jenis Pelayanan',
                state.serviceType,
                _formValues.serviceType,
                (value) {
                  setState(() {
                    _formValues
                      ..serviceType = value
                      ..serviceTypeName = value != null
                          ? state.serviceType
                              .firstWhere(
                                (s) => s.id == value,
                              )
                              .name
                          : null
                      ..route = null;
                  });
                },
                (serviceType) => serviceType.name,
                (serviceType) => serviceType.id,
                Icons.room_service,
                context,
              ),
              _buildDropdownCustom<RouteEntity>(
                'Rute Pengiriman',
                state.route
                    .where(
                      (route) =>
                          _formValues.serviceTypeName == null ||
                          route.serviceType == _formValues.serviceTypeName,
                    )
                    .toList(),
                _formValues.route,
                (value) => setState(() => _formValues.route = value),
                (route) => route.routeName,
                (route) => route.id,
                Icons.route,
                context,
              ),
              _buildTextField(
                'Total Colli',
                _formControllers.colli,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildTextButton(
                    'Clear',
                    _clearFields,
                  ),
                  const Spacer(),
                  _buildOutlinedButton(
                    'Cancel',
                    () async => context.router.maybePop(),
                  ),
                  const SizedBox(width: 8),
                  _buildElevatedButton(
                    'Next',
                    const Color.fromRGBO(29, 79, 215, 1),
                    _submitForm,
                  ),
                ],
              ),
            ],
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
    TextEditingController rightController,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: leftController,
                decoration: InputDecoration(
                  labelText: leftLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: rightController,
                decoration: InputDecoration(
                  labelText: rightLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    DateType dateType,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => _selectDate(context, dateType),
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

  Widget _buildDropdown(
    String label,
    List<List<dynamic>> options,
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
                (option) => DropdownMenuItem<String>(
                  value: option[0].toString(),
                  child: Text(option[1].toString()),
                ),
              )
              .toList(),
          onChanged: onChanged,
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
                  _getDisplayTextForDropdown(
                      selectedValue, options, getLabel, getValue, label),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      );

  String _getDisplayTextForDropdown<T>(
    String? selectedValue,
    List<T> options,
    String Function(T) getLabel,
    String Function(T) getValue,
    String label,
  ) {
    if (selectedValue == null || options.isEmpty) {
      return 'Pilih $label';
    }

    for (final option in options) {
      if (getValue(option) == selectedValue) {
        return getLabel(option);
      }
    }

    return 'Pilih $label';
  }

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
}

enum DateType { send, receive }

class ReceiptFormControllers {
  final colli = TextEditingController();
  final sender = TextEditingController();
  final receiver = TextEditingController();
  final receiptNumber = TextEditingController();
  final deliveryNote = TextEditingController();
  final senderAddress = TextEditingController();
  final receiverAddress = TextEditingController();
  final senderHp = TextEditingController();
  final receiverHp = TextEditingController();

  void clear() {
    colli.clear();
    sender.clear();
    receiver.clear();
    receiptNumber.clear();
    deliveryNote.clear();
    senderAddress.clear();
    receiverAddress.clear();
    senderHp.clear();
    receiverHp.clear();
  }

  void dispose() {
    colli.dispose();
    sender.dispose();
    receiver.dispose();
    receiptNumber.dispose();
    deliveryNote.dispose();
    senderAddress.dispose();
    receiverAddress.dispose();
    senderHp.dispose();
    receiverHp.dispose();
  }
}

class ReceiptFormValues {
  String? branchOffice;
  DateTime? dateSend;
  DateTime? dateReceive;
  String? relationAs;
  String? city;
  String? route;
  String? relation;
  String? serviceType;
  String? serviceTypeName;

  void clearSelections() {
    branchOffice = null;
    dateSend = null;
    dateReceive = null;
    relationAs = null;
    city = null;
    route = null;
    relation = null;
    serviceType = null;
    serviceTypeName = null;
  }
}

class ReceiptHeaderSection extends StatelessWidget {
  const ReceiptHeaderSection({super.key});

  static const Color headerColor = Color.fromRGBO(29, 79, 215, 1);

  @override
  Widget build(BuildContext context) => const DecoratedBox(
        decoration: BoxDecoration(color: headerColor),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
      );
}
