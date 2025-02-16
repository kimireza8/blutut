import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRelasi;
  String? selectedRoute;
  String? manualRelasi;
  String? manualRoute;
  DateTime? selectedDate;

  List<String> relasiOptions = ['Relasi 1', 'Relasi 2', 'Relasi 3', 'Lainnya'];
  List<String> routeOptions = ['Route A', 'Route B', 'Route C', 'Lainnya'];

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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Input Data Terima')),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Masukkan Data',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Kantor Cabang'),
                    GestureDetector(
                      onTap: () async => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Tanggal',
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
                          validator: (value) =>
                              value!.isEmpty ? 'Harus diisi' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField('Nama Relasi', relasiOptions, (value) {
                      setState(() {
                        selectedRelasi = value;
                        if (value != 'Lainnya') {
                          manualRelasi = null;
                        }
                      });
                    }),
                    if (selectedRelasi == 'Lainnya')
                      _buildTextField(
                        'Masukkan Nama Relasi',
                        onChanged: (val) => manualRelasi = val,
                      ),
                    _buildTextField('Pengirim'),
                    _buildTextField('Penerima'),
                    _buildTextField('No Resi'),
                    _buildTextField('No SJ'),
                    _buildDropdownField('Rute Pengiriman', routeOptions,
                        (value) {
                      setState(() {
                        selectedRoute = value;
                        if (value != 'Lainnya') {
                          manualRoute = null;
                        }
                      });
                    }),
                    if (selectedRoute == 'Lainnya')
                      _buildTextField(
                        'Masukkan Rute Pengiriman',
                        onChanged: (val) => manualRoute = val,
                      ),
                    _buildTextField(
                      'Total Coli',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String relasiFinal = selectedRelasi == 'Lainnya'
                                ? manualRelasi ?? ''
                                : selectedRelasi ?? '';
                            String routeFinal = selectedRoute == 'Lainnya'
                                ? manualRoute ?? ''
                                : selectedRoute ?? '';

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Data berhasil disimpan!\nRelasi: $relasiFinal\nRute: $routeFinal',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          'Simpan',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildTextField(
    String label, {
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          keyboardType: keyboardType,
          validator: (value) => value!.isEmpty ? 'Harus diisi' : null,
          onChanged: onChanged,
        ),
      );

  Widget _buildDropdownField(
    String label,
    List<String> options,
    Function(String?) onChanged,
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
          validator: (value) => value == null ? 'Pilih salah satu' : null,
        ),
      );
}
