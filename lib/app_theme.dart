import 'package:flutter/material.dart';
import 'package:respect/constants.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: Constants.dark100,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        titleTextStyle: Constants.largeBoldTextStyle,
        elevation: 0.1,
      ),
      // accentColor: Colors.orange,
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      primaryColor: Constants.dark100,
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        titleTextStyle:
            Constants.largeBoldTextStyle.copyWith(color: Colors.white),
        elevation: 0.1,
      ),
      // accentColor: Colors.orange,
      scaffoldBackgroundColor: Constants.dark100,
    );
  }
}
