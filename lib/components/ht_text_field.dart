import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../constants.dart';

class HTTextField extends StatelessWidget {
  HTTextField({
    super.key,
    this.controller,
    this.hintText,
    this.height = 48,
    this.suffixIcon,
    this.suffixText,
    this.suffix,
    this.clipBehavior = Clip.hardEdge,
    this.onChanged,
    this.inputFormatters,
    this.maxLines = 1,
    this.expands = false,
    this.keyboardType,
    this.error = false,
    this.errorText,
    this.textAlignVertical,
    this.obscureText = false,
    this.onSubmitted,
  });
  final TextEditingController? controller;
  final String? hintText;
  final double? height;
  final Widget? suffixIcon;
  final String? suffixText;
  final Widget? suffix;
  final Clip clipBehavior;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool expands;
  final TextInputType? keyboardType;
  final bool error;
  final String? errorText;
  final TextAlignVertical? textAlignVertical;
  final bool obscureText;

  final outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(12.0),
  );
  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: textAlignVertical,
      keyboardType: keyboardType,
      maxLines: maxLines,
      expands: expands,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      clipBehavior: clipBehavior,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontFamily: 'Spoqa Han Sans Neo',
        fontWeight: FontWeight.w400,
      ),
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        filled: true,
        fillColor: const Color(0xFFEEEEEE),
        errorText: error ? errorText : null,
        // errorStyle: Constants.textFieldErrorStyle.copyWith(color: Colors.black),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        errorBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
        border: InputBorder.none,
        hintText: hintText,
        suffixIcon: suffixIcon,
        suffixText: suffixText,
        suffix: suffix,
        suffixStyle: const TextStyle(
          color: Color(0xFF555555),
          fontSize: 14,
          fontFamily: 'Spoqa Han Sans Neo',
          fontWeight: FontWeight.w400,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF777777),
          fontSize: 14,
          fontFamily: 'Spoqa Han Sans Neo',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
