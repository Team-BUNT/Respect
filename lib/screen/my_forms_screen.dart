import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:respect/screen/make_form_screen.dart';
import '../components/form_card.dart';
import '../constants.dart';
import '../model/apply_form.dart';

class MyFormsScreen extends StatefulWidget {
  const MyFormsScreen({super.key});

  static String routeName = '/my_forms_screen';

  @override
  State<MyFormsScreen> createState() => _MyFormsScreenState();
}

class _MyFormsScreenState extends State<MyFormsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    const androidIdPlugin = AndroidId();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidId = await androidIdPlugin.getId();
      return androidId;
    } else {
      return null;
    }
  }

  bool isLoading = false;

  Future getMyForms() async {
    List<ApplyForm> tempList = [];

    final deviceId = await getDeviceId();

    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('forms')
        .where('deviceId', isEqualTo: deviceId)
        .orderBy('createAt')
        .get()
        .then(
      (snapshot) {
        for (var doc in snapshot.docs) {
          var document = doc.data();
          String deviceId = document['deviceId'];
          String name = document['name'];
          DateTime createAt = (document['createAt'] as Timestamp).toDate();
          String link = document['link'];

          ApplyForm form = ApplyForm(
            deviceId: deviceId,
            name: name,
            createAt: createAt,
            link: link,
          );
          tempList.add(form);
          setState(() {
            myFormList = tempList;
          });
        }
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  List<ApplyForm> myFormList = [];

  @override
  void initState() {
    getMyForms();
    tabController = TabController(
      length: 2,
      vsync: this,
      // animationDuration: Duration.zero,
    );
    tabController.addListener(_handleSelected);

    super.initState();
  }

  void _handleSelected() {
    setState(() {
      tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              '나의 신청폼',
              style: navTextStyle,
            ),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0.1,
            actions: [
              CupertinoButton(
                padding: const EdgeInsets.all(0.0),
                child: const Icon(
                  CupertinoIcons.add,
                  size: 22.0,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MakeFormScreen(onDismiss: getMyForms),
                    ),
                  );
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            color: Colors.black,
            displacement: 10.0,
            strokeWidth: 2.0,
            onRefresh: () async {
              await getMyForms();
              setState(() {});
            },
            child: Column(
              children: [
                if (myFormList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          isLoading ? '신청폼을 불러오는 중입니다..' : '아직 작성한 신청폼이 없습니다.',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF636366),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  TabBar(
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 16.0),
                                StaggeredGrid.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  children: myFormList.map((form) {
                                    return FormCard(
                                      isResultView: false,
                                      applyForm: form,
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // 결과
                      ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 16.0),
                                StaggeredGrid.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  children: myFormList.map((form) {
                                    return FormCard(
                                      isResultView: true,
                                      applyForm: form,
                                    );
                                  }).toList(),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
