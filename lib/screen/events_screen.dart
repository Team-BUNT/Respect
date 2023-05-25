import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:respect/components/event_card.dart';
import 'package:respect/components/respect_app_bar.dart';
import 'package:respect/model/event_genre.dart';
import 'package:respect/screen/event_detail_screen.dart';
import '../components/filter_menu_chip.dart';
import '../constants.dart';
import '../model/province.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventScreen extends StatefulWidget {
  static String routeName = "/";

  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late final TabController tabController;
  int currentEventTypeIndex = 0;

  Province selectedProvince = Province.all;
  EventGenre selectedGenre = EventGenre.all;

  Stream<QuerySnapshot> _eventsStream = FirebaseFirestore.instance
      .collection('events')
      .where('isShowing', isEqualTo: true)
      .where('date', isGreaterThanOrEqualTo: DateTime.now())
      .orderBy('date')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: RespectAppBar(
          onSelected: (typeIndex) {
            setState(() {
              currentEventTypeIndex = typeIndex;
            });
          },
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  PullDownButton(
                    itemBuilder: (context) => Province.values.map((province) {
                      return PullDownMenuItem.selectable(
                        onTap: () {
                          setState(() {
                            selectedProvince = province;

                            if (selectedGenre == EventGenre.all) {
                              if (selectedProvince == Province.all) {
                                _eventsStream = FirebaseFirestore.instance
                                    .collection('events')
                                    .where('isShowing', isEqualTo: true)
                                    .where('date',
                                        isGreaterThanOrEqualTo: DateTime.now())
                                    .orderBy('date')
                                    .snapshots();
                              } else {
                                _eventsStream = FirebaseFirestore.instance
                                    .collection('events')
                                    .where('isShowing', isEqualTo: true)
                                    .where('date',
                                        isGreaterThanOrEqualTo: DateTime.now())
                                    .where('province',
                                        isEqualTo:
                                            selectedProvince.convertToString)
                                    .orderBy('date')
                                    .snapshots();
                              }
                            } else {
                              if (selectedProvince == Province.all) {
                                _eventsStream = FirebaseFirestore.instance
                                    .collection('events')
                                    .where('isShowing', isEqualTo: true)
                                    .where('date',
                                        isGreaterThanOrEqualTo: DateTime.now())
                                    .where('genre',
                                        arrayContains:
                                            selectedGenre.convertToString)
                                    .orderBy('date')
                                    .snapshots();
                              } else {
                                _eventsStream = FirebaseFirestore.instance
                                    .collection('events')
                                    .where('isShowing', isEqualTo: true)
                                    .where('date',
                                        isGreaterThanOrEqualTo: DateTime.now())
                                    .where('province',
                                        isEqualTo:
                                            selectedProvince.convertToString)
                                    .where('genre',
                                        arrayContains:
                                            selectedGenre.convertToString)
                                    .orderBy('date')
                                    .snapshots();
                              }
                            }
                          });
                        },
                        title: province.convertToString,
                      );
                    }).toList(),
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      child: FilterMenuChip(
                          chipName: selectedProvince.convertToString),
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  PullDownButton(
                    itemBuilder: (context) => EventGenre.values.map((genre) {
                      return PullDownMenuItem.selectable(
                        onTap: () {
                          setState(() {
                            selectedGenre = genre;

                            if (selectedProvince == Province.all) {
                              if (selectedGenre == EventGenre.all) {
                                _eventsStream = FirebaseFirestore.instance
                                    .collection('events')
                                    .where('isShowing', isEqualTo: true)
                                    .where('date',
                                        isGreaterThanOrEqualTo: DateTime.now())
                                    .orderBy('date')
                                    .snapshots();
                              } else {
                                _eventsStream = FirebaseFirestore.instance
                                    .collection('events')
                                    .where('isShowing', isEqualTo: true)
                                    .where('date',
                                        isGreaterThanOrEqualTo: DateTime.now())
                                    .where('genre',
                                        arrayContains:
                                            selectedGenre.convertToString)
                                    .orderBy('date')
                                    .snapshots();
                              }
                            } else {
                              if (selectedGenre == EventGenre.all) {
                                _eventsStream = FirebaseFirestore.instance
                                    .collection('events')
                                    .where('isShowing', isEqualTo: true)
                                    .where('date',
                                        isGreaterThanOrEqualTo: DateTime.now())
                                    .where('province',
                                        isEqualTo:
                                            selectedProvince.convertToString)
                                    .orderBy('date')
                                    .snapshots();
                              } else {
                                _eventsStream = FirebaseFirestore.instance
                                    .collection('events')
                                    .where('isShowing', isEqualTo: true)
                                    .where('date',
                                        isGreaterThanOrEqualTo: DateTime.now())
                                    .where('province',
                                        isEqualTo:
                                            selectedProvince.convertToString)
                                    .where('genre',
                                        arrayContains:
                                            selectedGenre.convertToString)
                                    .orderBy('date')
                                    .snapshots();
                              }
                            }
                          });
                        },
                        title: genre.convertToString,
                      );
                    }).toList(),
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      child: FilterMenuChip(
                          chipName: selectedGenre.convertToString),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'D-day 순',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: dDayTextColor,
                      fontFamily: 'Pretendard',
                    ),
                  )
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _eventsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('뭔가가 잘못 됐다..!'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2.0,
                    ),
                  );
                }

                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 39.0 / 74.0),
                  itemBuilder: ((context, index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return CupertinoButton(
                        padding: const EdgeInsets.all(0.0),
                        child: EventCard(event: documentSnapshot),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            EventDetailScreen.routeName,
                            arguments: documentSnapshot
                          );
                        });
                  }),
                  itemCount: snapshot.data!.docs.length,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}