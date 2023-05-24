import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class FilterMenuChip extends StatefulWidget {
  const FilterMenuChip({super.key, required this.chipName});
  
  final String chipName;

  @override
  State<FilterMenuChip> createState() => _FilterMenuChipState();
}

class _FilterMenuChipState extends State<FilterMenuChip> {
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Row(
        children: [
          Text(widget.chipName),
          const SizedBox(width: 6.0),
          const Icon(
            CupertinoIcons.chevron_down,
            color: filterMenuChipTextColor,
            size: 11.0,
          )
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
        side: const BorderSide(color: filterMenuChipBorderColor, width: 1),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
