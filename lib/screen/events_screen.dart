import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:respect/components/event_card.dart';
import 'package:respect/components/respect_app_bar.dart';
import 'package:respect/model/event_genre.dart';
import 'package:respect/screen/event_detail_screen.dart';
import 'package:respect/screen/filter_chips_screen.dart';
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

  final Stream<QuerySnapshot> _eventsStream =
      FirebaseFirestore.instance.collection('events').snapshots();

  // final eventsRef =
  //     FirebaseFirestore.instance.collection('events').withConverter<Event>(
  //           fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
  //           toFirestore: (event, _) => event.toJson(),
  //         );

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
        body: ListView(
          children: [
            FilterChipsScreen(selectedProvince: (province) {
              setState(() {
                selectedProvince = province;
              });
            }, selectedGenre: (genre) {
              setState(() {
                selectedGenre = genre;
              });
            }),
            StreamBuilder<QuerySnapshot>(
              stream: _eventsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 39.0 / 74.0),
                    itemBuilder: ((context, index) {
                      final DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      return CupertinoButton(
                          padding: const EdgeInsets.all(0.0),
                          child: EventCard(event: documentSnapshot),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, EventDetailView.routeName);
                          });
                    }),
                    itemCount: snapshot.data!.docs.length,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
