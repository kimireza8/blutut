import 'package:flutter/material.dart';

class CustomDropdownDialog<T> extends StatefulWidget {
  const CustomDropdownDialog({
    required this.title,
    required this.icon,
    required this.options,
    required this.getLabel,
    required this.getValue,
    required this.onChanged,
    super.key,
    this.selectedValue,
  });
  final String title;
  final IconData icon;
  final List<T> options;
  final String? selectedValue;
  final String Function(T) getLabel;
  final String Function(T) getValue;
  final Function(String?) onChanged;

  @override
  State<CustomDropdownDialog<T>> createState() =>
      _CustomDropdownDialogState<T>();
}

class _CustomDropdownDialogState<T> extends State<CustomDropdownDialog<T>> {
  late List<T> filteredOptions;
  String? selectedItem;
  TextEditingController searchController = TextEditingController();
  final Color primaryColor = const Color.fromRGBO(29, 79, 215, 1);

  @override
  void initState() {
    super.initState();
    filteredOptions = widget.options;
    selectedItem = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(widget.icon, size: 24, color: Colors.black87),
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (query) {
                  setState(() {
                    filteredOptions = widget.options
                        .where(
                          (item) => widget
                              .getLabel(item)
                              .toLowerCase()
                              .contains(query.toLowerCase()),
                        )
                        .toList();
                  });
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: filteredOptions.length,
                  itemBuilder: (context, index) {
                    var isSelected =
                        selectedItem == widget.getValue(filteredOptions[index]);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItem =
                              widget.getValue(filteredOptions[index]);
                        });
                      },
                      child: ColoredBox(
                        color: isSelected
                            ? primaryColor.withOpacity(0.2)
                            : Colors.transparent,
                        child: ListTile(
                          title: Text(
                            widget.getLabel(filteredOptions[index]),
                            style: TextStyle(
                              color: isSelected ? primaryColor : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: primaryColor),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child:
                        Text('Kembali', style: TextStyle(color: primaryColor)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: selectedItem != null
                        ? () {
                            widget.onChanged(selectedItem);
                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text(
                      'Pilih',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
