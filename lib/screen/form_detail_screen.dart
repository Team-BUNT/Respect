import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:respect/screen/form_screen.dart';

import '../constants.dart';

class FormDetailScreen extends StatefulWidget {
  const FormDetailScreen({super.key});

  static String routeName = '/form_detail_screen';

  @override
  State<FormDetailScreen> createState() => _FormDetailScreenState();
}

class _FormDetailScreenState extends State<FormDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      // animationDuration: Duration.zero,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

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
        flexibleSpace: const Divider(
          color: Color(0xFFE2E2E2),
          thickness: 1.0,
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.black,
          tabs: [
            Tab(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '나의 신청폼',
                  style: tabController.index == 0
                      ? selectedTabTextStyle
                      : unselectedTabTextStyle,
                ),
              ),
            ),
            Tab(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  '결과',
                  style: tabController.index == 1
                      ? selectedTabTextStyle
                      : unselectedTabTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: TabBarView(
        controller: tabController,
        children: [
          FormScreen(),
          const Center(
            child: Text('결과'),
          )
        ],
      ),
    );
  }
}
