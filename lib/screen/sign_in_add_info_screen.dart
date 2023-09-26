import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:respect/components/ht_button.dart';
import 'package:respect/components/ht_text_field.dart';
import 'package:respect/constants.dart';

import '../components/checkbox_term_list_tile.dart';
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
  bool agreePrivacy = false;
  bool agreePurchase = false;
  bool agreeMarketing = false;

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
              hintText: "댄서 네임 (행사 참가시 사용됩니다.)",
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
            //MARK: - 이용 약관 동의
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '이용 약관 동의',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 16.0),
                checkAllAgree(),
                const SizedBox(height: 16.0),
                CheckboxTermListTile(
                  value: agreePrivacy,
                  title: '[필수] 이용약관',
                  onChanged: (newValue) {
                    setState(() => agreePrivacy = newValue!);
                  },
                ),
                const SizedBox(height: 4.0),
                CheckboxTermListTile(
                  value: agreePurchase,
                  title: '[필수] 개인정보 수집, 이용 동의서',
                  onChanged: (newValue) {
                    setState(() => agreePurchase = newValue!);
                  },
                ),
                const SizedBox(height: 4.0),
                CheckboxTermListTile(
                  value: agreeMarketing,
                  title: '[선택] 마케팅 정보 수신동의',
                  onChanged: (newValue) {
                    setState(() => agreeMarketing = newValue!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
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

  Widget checkAllAgree() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 1.0,
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color(0xFFCCCCCC),
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (agreePrivacy && agreePurchase && agreeMarketing)
                Image.asset(
                  'asset/icons/checkmark_circle_fill.png',
                  width: 20.0,
                  height: 20.0,
                )
              else
                Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 12.0),
              const Text(
                '전체동의',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        final newValue = (agreePrivacy && agreePurchase && agreeMarketing);

        setState(() {
          agreePrivacy = !newValue;
          agreePurchase = !newValue;
          agreeMarketing = !newValue;
        });
      },
    );
  }
}
