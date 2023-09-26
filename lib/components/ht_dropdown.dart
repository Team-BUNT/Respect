import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class HTDropdown extends StatefulWidget {
  const HTDropdown({
    Key? key,
    required this.hintText,
    required this.items,
    this.selectedValue,
    this.onChanged,
  }) : super(key: key);
  final String hintText;
  final List<String> items;
  final String? selectedValue;
  final Function(String?)? onChanged;

  @override
  State<HTDropdown> createState() => _HTDropdownState();
}

class _HTDropdownState extends State<HTDropdown> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String hintText = widget.hintText;
    List<String> items = widget.items;
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          hintText,
          style: const TextStyle(
            color: Colors.black38,
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.20,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.20,
                    ),
                  ),
                ))
            .toList(),
        value: widget.selectedValue,
        onChanged: widget.onChanged,

        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 48,
          width: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),

        dropdownStyleData: DropdownStyleData(
          maxHeight: 500,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        iconStyleData: IconStyleData(
            iconSize: 12,
            icon: Image.asset(
                width: 12, height: 12, "asset/icons/triangle_down.png"),
            iconEnabledColor: Colors.black),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),

        //This to clear the search value when you close the menu
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            textEditingController.clear();
          }
        },
      ),
    );
  }
}
