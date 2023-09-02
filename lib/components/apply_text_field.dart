import 'package:flutter/material.dart';

class ApplyTextField extends StatelessWidget {
  ApplyTextField({
    super.key,
    required this.hintText,
    this.suffix,
    this.obscureText = false,
    this.maxLength,
    this.onChanged,
  });

  final String hintText;
  final Widget? suffix;
  final bool obscureText;
  final int? maxLength;
  final Function(String)? onChanged;

  final outlineInputBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(12.0),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFAEAEB2),
          fontSize: 15,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 1.47,
        ),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        errorBorder: outlineInputBorder,
        focusedErrorBorder: outlineInputBorder,
        filled: true,
        fillColor: const Color(0xFFEEEEEE),
        suffixIcon: Center(widthFactor: 2, child: suffix),
        counterText: '',
      ),
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        height: 1.47,
      ),
      cursorColor: Colors.black,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
    );
  }
}
