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
import '../../../domain/entities/receipt/receipt_detail_entity.dart';
import '../../../domain/entities/receipt/receipt_entity.dart';
import '../../../domain/entities/receipt/receipt_input_entity.dart';
import '../../receipt/bloc/receipt_bloc.dart';
import '../cubit/receipt_detail_cubit.dart';

@RoutePage()
class EditReceiptDetailPage extends StatefulWidget {
  const EditReceiptDetailPage({
    required this.receipt,
    super.key,
  });

  final ReceiptEntity receipt;

  @override
  State<EditReceiptDetailPage> createState() => _EditReceiptDetailPageState();
}

class _EditReceiptDetailPageState extends State<EditReceiptDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _formControllers = ReceiptFormControllers();
  final _formValues = ReceiptFormValues();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    ReceiptDetailCubit cubit = context.read<ReceiptDetailCubit>();
    cubit.fetchReferenceData();
    cubit.fetchReceiptDetail(widget.receipt.id);
  }

  @override
  void dispose() {
    _formControllers.dispose();
    super.dispose();
  }

  void _initializeFormValues(ReceiptDetailLoaded state) {
    ReceiptDetailEntity receipt = state.detailReceiptEntity;

    _formControllers.setValues(
      receiptNumber: receipt.receiptNumber,
      passDocument: receipt.passDocument,
      totalCollies: receipt.totalCollies,
      shipperName: receipt.shipperName,
      consigneeName: receipt.consigneeName,
      shipperAddress: receipt.shipperAddress,
      consigneeAddress: receipt.consigneeAddress,
      shipperPhone: receipt.shipperPhone ?? '',
      consigneePhone: receipt.consigneePhone,
    );

    setState(() {
      _formValues
        ..branchOffice = receipt.branch
        ..relation = receipt.customer
        ..relationAs = receipt.customerRole
        ..city = receipt.consigneeCity
        ..route = receipt.route
        ..serviceType = receipt.serviceType
        ..dateSend = _parseDate(receipt.date)
        ..dateReceive = _parseDate(receipt.incomingDate);
    });
  }

  DateTime? _parseDate(String dateString) =>
      dateString.isNotEmpty ? DateTime.parse(dateString) : null;

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
  Widget build(BuildContext context) =>
      BlocListener<ReceiptDetailCubit, ReceiptDetailState>(
        listener: (context, state) {
          if (state is ReceiptDetailLoaded) {
            _initializeFormValues(state);
          }
        },
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
                          child: BlocBuilder<ReceiptDetailCubit,
                              ReceiptDetailState>(
                            builder: (context, state) {
                              if (state is ReceiptDetailLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is ReceiptDetailDataLoaded) {
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

  Widget _buildForm(ReceiptDetailDataLoaded state) => Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormDropdown<OrganizationEntity>(
                label: 'Kantor Cabang',
                items: state.organizations,
                selectedValue: _formValues.branchOffice,
                getValue: (office) => office.id,
                getLabel: (office) => office.name,
                onChanged: (value) =>
                    setState(() => _formValues.branchOffice = value),
              ),
              FormDateField(
                label: 'Tanggal Kirim',
                selectedDate: _formValues.dateSend,
                onTap: () => _selectDate(context, DateType.send),
              ),
              FormDateField(
                label: 'Tanggal Diterima',
                selectedDate: _formValues.dateReceive,
                onTap: () => _selectDate(context, DateType.receive),
              ),
              FormDropdown<RelationEntity>(
                label: 'Nama Relasi',
                items: state.relations,
                selectedValue: _formValues.relation,
                getValue: (relation) => relation.id,
                getLabel: (relation) => relation.name,
                onChanged: (value) =>
                    setState(() => _formValues.relation = value),
              ),
              FormDropdown<Map<String, String>>(
                label: 'Relasi Sebagai',
                items: const [
                  {'id': '1', 'name': 'Pengirim'},
                  {'id': '2', 'name': 'Penerima'},
                ],
                selectedValue: _formValues.relationAs,
                getValue: (option) => option['id']!,
                getLabel: (option) => option['name']!,
                onChanged: (value) =>
                    setState(() => _formValues.relationAs = value),
              ),
              FormTwoColumnField(
                leftLabel: 'Pengirim',
                rightLabel: 'Penerima',
                leftController: _formControllers.sender,
                rightController: _formControllers.receiver,
              ),
              FormTwoColumnField(
                leftLabel: 'Alamat Pengirim',
                rightLabel: 'Alamat Penerima',
                leftController: _formControllers.senderAddress,
                rightController: _formControllers.receiverAddress,
              ),
              FormTwoColumnField(
                leftLabel: 'No Hp Pengirim',
                rightLabel: 'No Hp Penerima',
                leftController: _formControllers.senderHp,
                rightController: _formControllers.receiverHp,
              ),
              FormDropdown<ConsigneeCityEntity>(
                label: 'Kota Tujuan',
                items: state.cities,
                selectedValue: _formValues.city,
                getValue: (city) => city.id,
                getLabel: (city) => city.name,
                onChanged: (value) => setState(() => _formValues.city = value),
              ),
              FormTextField(
                label: 'Nomor Resi',
                controller: _formControllers.receiptNumber,
              ),
              FormTextField(
                label: 'Nomor Surat Jalan',
                controller: _formControllers.deliveryNote,
              ),
              FormDropdown<ServiceTypeEntity>(
                label: 'Jenis Pelayanan',
                items: state.serviceTypes,
                selectedValue: _formValues.serviceType,
                getValue: (serviceType) => serviceType.id,
                getLabel: (serviceType) => serviceType.name,
                onChanged: (value) =>
                    setState(() => _formValues.serviceType = value),
              ),
              FormDropdown<RouteEntity>(
                label: 'Rute Pengiriman',
                items: state.routes,
                selectedValue: _formValues.route,
                getValue: (route) => route.id,
                getLabel: (route) => route.routeName,
                onChanged: (value) => setState(() => _formValues.route = value),
              ),
              FormTextField(
                label: 'Total Colli',
                controller: _formControllers.colli,
              ),
              const SizedBox(height: 20),
              FormActionButtons(
                onClear: _clearFields,
                onCancel: () async => context.router.maybePop(),
                onSubmit: _submitForm,
              ),
            ],
          ),
        ),
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

  void setValues({
    required String receiptNumber,
    required String passDocument,
    required String totalCollies,
    required String shipperName,
    required String consigneeName,
    required String shipperAddress,
    required String consigneeAddress,
    required String shipperPhone,
    required String consigneePhone,
  }) {
    this.receiptNumber.text = receiptNumber;
    deliveryNote.text = passDocument;
    colli.text = totalCollies;
    sender.text = shipperName;
    receiver.text = consigneeName;
    senderAddress.text = shipperAddress;
    receiverAddress.text = consigneeAddress;
    senderHp.text = shipperPhone;
    receiverHp.text = consigneePhone;
  }

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

  void clearSelections() {
    branchOffice = null;
    dateSend = null;
    dateReceive = null;
    relationAs = null;
    city = null;
    route = null;
    relation = null;
    serviceType = null;
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

class FormDropdown<T> extends StatelessWidget {
  const FormDropdown({
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.getValue,
    required this.getLabel,
    required this.onChanged,
    super.key,
  });
  final String label;
  final List<T> items;
  final String? selectedValue;
  final String Function(T) getValue;
  final String Function(T) getLabel;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          value: selectedValue,
          items: items.map((item) {
            String value = getValue(item);
            return DropdownMenuItem<String>(
              value: value,
              child: Text(getLabel(item)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      );
}

class FormTextField extends StatelessWidget {
  const FormTextField({
    required this.label,
    required this.controller,
    super.key,
  });
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      );
}

class FormTwoColumnField extends StatelessWidget {
  const FormTwoColumnField({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftController,
    required this.rightController,
    super.key,
  });
  final String leftLabel;
  final String rightLabel;
  final TextEditingController leftController;
  final TextEditingController rightController;

  @override
  Widget build(BuildContext context) => Padding(
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
}

class FormDateField extends StatelessWidget {
  const FormDateField({
    required this.label,
    required this.selectedDate,
    required this.onTap,
    super.key,
  });
  final String label;
  final DateTime? selectedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: const Icon(Icons.calendar_today),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
}

class FormActionButtons extends StatelessWidget {
  const FormActionButtons({
    required this.onClear,
    required this.onCancel,
    required this.onSubmit,
    super.key,
  });
  final VoidCallback onClear;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  static const Color primaryColor = Color.fromRGBO(29, 79, 215, 1);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            child: const Text('Clear'),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onSubmit,
            child: const Text('Next', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
}
