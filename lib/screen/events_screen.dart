import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:respect/components/event_card.dart';
import 'package:respect/components/respect_app_bar.dart';
import 'package:respect/model/event_genre.dart';
import 'package:respect/screen/event_detail_screen.dart';
import 'package:respect/screen/events_view_model.dart';
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

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<EventsViewModel>(context, listen: false);
    viewModel.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EventsViewModel>(context);
    return DefaultTabController(
      length: 10,
      child: Scaffold(
        appBar: RespectAppBar(
          onSelected: (typeIndex) {
            viewModel.currentEventTypeIndex = typeIndex;
            viewModel.filterEvent();
          },
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            color: Colors.black,
            displacement: 10.0,
            strokeWidth: 2.0,
            onRefresh: () async {
              viewModel.retrievEvents();
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
                                viewModel.selectedProvince = province;
                                viewModel.filterEvent();
                              });
                            },
                            title: province.convertToString,
                          );
                        }).toList(),
                        buttonBuilder: (context, showMenu) => CupertinoButton(
                          onPressed: showMenu,
                          padding: EdgeInsets.zero,
                          child: FilterMenuChip(
                            chipName:
                                viewModel.selectedProvince.convertToString,
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
                              viewModel.selectedGenre = genre;
                              viewModel.filterEvent();
                            },
                            title: genre.convertToString,
                          );
                        }).toList(),
                        buttonBuilder: (context, showMenu) => CupertinoButton(
                          onPressed: showMenu,
                          padding: EdgeInsets.zero,
                          child: FilterMenuChip(
                            chipName: viewModel.selectedGenre.convertToString,
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
                if (viewModel.eventList.isEmpty)
                  const Center(
                    child: Text('불러오는 중...'),
                  )
                else
                  StaggeredGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    children: viewModel.filteredEventList.map((event) {
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
