import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:respect/model/apply_form.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screen/form_detail_screen.dart';

class FormCard extends StatelessWidget {
  const FormCard(
      {super.key, required this.isResultView, required this.applyForm});

  final ApplyForm applyForm;
  final bool isResultView;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE5E5EA),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.all(16.0),
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const Text(
                  '888888888888888888888',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.transparent,
                    fontFamily: 'Pretendard',
                  ),
                  maxLines: 2,
                ),
                Text(
                  applyForm.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Pretendard',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              DateFormat('yyyy.MM.dd').format(applyForm.createAt),
              style: const TextStyle(
                height: 1.0,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF48484A),
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
        onPressed: () async {
          if (isResultView) {
            final url = Uri.parse('https://www.naver.com');

            if (await canLaunchUrl(url)) {
              launchUrl(url);
            }
            print('결과 창');
          } else {
            Navigator.pushNamed(
              context,
              FormDetailScreen.routeName,
            );
          }
        },
      ),
    );
  }
}
