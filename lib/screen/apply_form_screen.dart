import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../constants.dart';

class ApplyFormScreen extends StatefulWidget {
  const ApplyFormScreen({super.key});

  static String routeName = '/apply_form_screen';

  @override
  State<ApplyFormScreen> createState() => _ApplyFormScreenState();
}

class _ApplyFormScreenState extends State<ApplyFormScreen> {
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
        actions: [
          PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                title: '링크 복사하기',
                icon: Icons.content_copy_rounded,
                onTap: () {},
              ),
              PullDownMenuItem(
                title: '수정하기',
                icon: CupertinoIcons.pencil,
                onTap: () {},
              ),
              PullDownMenuItem(
                title: '삭제하기',
                icon: CupertinoIcons.trash,
                isDestructive: true,
                onTap: () {},
              ),
            ],
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.ellipsis,
                size: 24.0,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
