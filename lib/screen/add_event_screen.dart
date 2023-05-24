import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});

  static String routeName = "/add_event_screen";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Add Event Screen'),
      ),
      body: Center(
        child: Text('Add Event Screen'),
      ),
    );
  }
}
