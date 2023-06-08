import 'package:flutter/material.dart';
import 'package:respect/screen/form_screen.dart';

import '../constants.dart';

class FormDetailScreen extends StatefulWidget {
  const FormDetailScreen({super.key});

  static String routeName = '/form_detail_screen';

  @override
  State<FormDetailScreen> createState() => _FormDetailScreenState();
}

class _FormDetailScreenState extends State<FormDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '신청폼',
          style: navTextStyle,
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.1,
      ),
      backgroundColor: Colors.white,
      body: const Text('asdfasd')
    );
  }
}
