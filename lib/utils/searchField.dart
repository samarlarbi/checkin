import 'package:checkin/utils/colors.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Rebuild the widget when the focus state changes
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Background,
      padding: EdgeInsets.only(bottom: 10, top: 20),
      child: TextField(
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Search',
          suffixIcon: Icon(
            Icons.search,
            color: _focusNode.hasFocus ? Primary : Colors.grey,
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Primary, width: 2),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
