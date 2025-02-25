import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    required this.onSearch, super.key,
    this.hintText = 'Search',
  });

  final Function(String) onSearch;
  final String hintText;

  @override
  Widget build(BuildContext context) => Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: onSearch,
      ),
    );
}
