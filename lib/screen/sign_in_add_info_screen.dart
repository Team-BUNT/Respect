import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:respect/components/ht_button.dart';
import 'package:respect/components/ht_text_field.dart';
import 'package:respect/constants.dart';

import '../components/ht_dropdown.dart';

class SignInAddInfoScreen extends StatefulWidget {
  const SignInAddInfoScreen({super.key});

  static String routeName = '/signin/addinfo';

  @override
  State<SignInAddInfoScreen> createState() => _SignInAddInfoScreenState();
}

class _SignInAddInfoScreenState extends State<SignInAddInfoScreen> {
  String? year;
  String? month;
  String? day;

  final List<String> years = List.generate(100, (index) {
    final num = DateTime.now().year - index;
    return num.toString();
  });

  final List<String> months = List.generate(12, (index) {
    final num = index + 1;
    return num.toString().padLeft(2, '0');
  });

  final List<String> days = List.generate(31, (index) {
    final num = index + 1;
    return num.toString().padLeft(2, "0");
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("추가 정보 입력")),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('어서오세요! 🪩 \nHYPETOWN에.',
                style: Constants.title2TextStyle
                    .copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 32),
            HTTextField(
              hintText: "이름",
            ),
            const SizedBox(height: 12),
            HTTextField(
              hintText: "댄서 네임",
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                flex: 140,
                child: HTDropdown(
                  hintText: "1996",
                  items: years,
                  selectedValue: year,
                  onChanged: (value) {
                    setState(() {
                      year = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 90,
                child: HTDropdown(
                  hintText: "12",
                  items: months,
                  selectedValue: month,
                  onChanged: (value) {
                    setState(() {
                      month = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 90,
                child: HTDropdown(
                  hintText: "12",
                  items: days,
                  selectedValue: day,
                  onChanged: (value) {
                    setState(() {
                      day = value;
                    });
                  },
                ),
              ),
            ]),
            const Spacer(),
            HTButton(
              title: "회원 가입",
              titleColor: Colors.white,
              backgroundColor: Constants.dark100,
              onPressed: () {},
            )
          ],
        ),
      )),
    );
  }
}
