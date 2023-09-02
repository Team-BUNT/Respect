import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:respect/components/event_card.dart';
import 'package:respect/components/respect_app_bar.dart';
import 'package:respect/model/event_genre.dart';
import 'package:respect/screen/event_detail_screen.dart';
import 'package:respect/utils/firestore_services.dart';
import '../components/filter_menu_chip.dart';
import '../constants.dart';
import '../model/event.dart';
import '../model/province.dart';

class EventScreen extends StatefulWidget {
  static String routeName = '/';

  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late final TabController tabController;
  int currentEventTypeIndex = 0;

  Province selectedProvince = Province.all;
  EventGenre selectedGenre = EventGenre.all;

  List<DanceEvent> eventList = [];
  List<DanceEvent> filteredEventList = [];

  Future getEvents() async {
    debugPrint("DEBUG: getEvents $eventList");

    eventList = await FirestoreService.getAllDanceEvents();

    setState(() {});
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  void filterEvent() {
    filteredEventList = eventList;

    switch (currentEventTypeIndex) {
      case 1:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('배틀'),
            )
            .toList();
      case 2:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('퍼포먼스'),
            )
            .toList();
      case 3:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('경연'),
            )
            .toList();
      case 4:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('파티'),
            )
            .toList();
      case 5:
        filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('기타'),
            )
            .toList();
    }

    if (selectedProvince != Province.all) {
      filteredEventList = filteredEventList
          .where(
            (event) =>
                event.provinance!.startsWith(selectedProvince.convertToString),
          )
          .toList();
    }

    if (selectedGenre != EventGenre.all) {
      filteredEventList = filteredEventList
          .where(
            (event) => event.genres!.contains(selectedGenre.convertToString),
          )
          .toList();
    }
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
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.black,
            displacement: 10.0,
            strokeWidth: 2.0,
            onRefresh: () async {
              eventList.clear();
              await getEvents();
              filterEvent();
              setState(() {});
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      PullDownButton(
                        itemBuilder: (context) =>
                            Province.values.map((province) {
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
                        itemBuilder: (context) =>
                            EventGenre.values.map((genre) {
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
                  StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    children: filteredEventList.map((event) {
                      return CupertinoButton(
                        padding: const EdgeInsets.all(0.0),
                        child: EventCard(event: event),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, EventDetailScreen.routeName,
                              arguments: event);
                        },
                      );
                    }).toList(),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
