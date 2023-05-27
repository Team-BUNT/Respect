import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:respect/components/event_card.dart';
import 'package:respect/components/respect_app_bar.dart';
import 'package:respect/model/event_genre.dart';
import 'package:respect/screen/event_detail_screen.dart';
import '../components/filter_menu_chip.dart';
import '../constants.dart';
import '../model/event.dart';
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

  List<Event> eventList = [];
  List<Event> filteredEventList = [];

  Future getEvents() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('isShowing', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('date')
        .get();

    for (var doc in snapshot.docs) {
      var document = doc.data() as Map<String, dynamic>;
      String id = document['id'];
      String posterURL = document['posterURL'];
      String name = document['name'];
      String province = document['province'];
      String location = document['location'];
      Timestamp date = document['date'];
      Timestamp? dueDate = document['dueDate'];
      String type = document['type'];
      List<String> genre = List<String>.from(document['genre']);
      String? account = document['account'];
      String? link = document['link'];
      String? detail = document['detail'];
      String? hostName = document['hostName'];
      String? hostContact = document['hostContact'];
      bool? isShowing = document['isShowing'];

      Event event = Event(
        id: id,
        posterURL: posterURL,
        name: name,
        province: province,
        location: location,
        date: date,
        dueDate: dueDate,
        type: type,
        genre: genre,
        account: account,
        link: link,
        detail: detail,
        hostName: hostName,
        hostContact: hostContact,
        isShowing: isShowing,
      );
      setState(() {
        eventList.add(event);
        filteredEventList = eventList;
      });
    }
  }

  void filterEvent() {
    filteredEventList = eventList;

    switch (currentEventTypeIndex) {
      case 0:
      case 1:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type.startsWith('배틀'),
            )
            .toList();
      case 2:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type.startsWith('퍼포먼스'),
            )
            .toList();
      case 3:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type.startsWith('경연'),
            )
            .toList();
      case 4:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type.startsWith('파티'),
            )
            .toList();
      case 5:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type.startsWith('기타'),
            )
            .toList();
    }

    if (selectedProvince != Province.all) {
      filteredEventList = filteredEventList
          .where(
            (event) =>
                event.province.startsWith(selectedProvince.convertToString),
          )
          .toList();
    }

    if (selectedGenre != EventGenre.all) {
      filteredEventList = filteredEventList
          .where(
            (event) => event.genre.contains(selectedGenre.convertToString),
          )
          .toList();
    }
  }

  @override
  void initState() {
    getEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: RespectAppBar(
          onSelected: (typeIndex) {
            setState(() {
              currentEventTypeIndex = typeIndex;
              filterEvent();
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
                            filterEvent();
                          });
                        },
                        title: province.convertToString,
                      );
                    }).toList(),
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      child: FilterMenuChip(
                        chipName: selectedProvince.convertToString,
                      ),
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
                            filterEvent();
                          });
                        },
                        title: genre.convertToString,
                      );
                    }).toList(),
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      onPressed: showMenu,
                      padding: EdgeInsets.zero,
                      child: FilterMenuChip(
                        chipName: selectedGenre.convertToString,
                      ),
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
            if (eventList.isEmpty)
              const Center(
                child: Text('불러오는 중...'),
              )
            else
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 39.0 / 74.0),
                itemBuilder: ((context, index) {
                  Event event = filteredEventList[index];
                  return CupertinoButton(
                    padding: const EdgeInsets.all(0.0),
                    child: EventCard(event: event),
                    onPressed: () {
                      Navigator.pushNamed(context, EventDetailScreen.routeName,
                          arguments: event);
                    },
                  );
                }),
                itemCount: filteredEventList.length,
              )
          ],
        ),
      ),
    );
  }
}
