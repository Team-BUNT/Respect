import 'package:flutter/material.dart';

import '../constants.dart';

class MyEntryScreen extends StatelessWidget {
  const MyEntryScreen({super.key});
  static String routeName = 'my_entry_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "나의 내역",
          style: navTextStyle,
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.1,
      ),
      body: const Column(
        children: [
          Row(
            children: [],
          )
        ],
      ),
    );
  }
}
