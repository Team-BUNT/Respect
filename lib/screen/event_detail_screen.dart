import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventDetailView extends StatelessWidget {
  const EventDetailView({super.key});

  static String routeName = "/event_detail_screen";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Event Detail Screen'),
      ),
      body: Center(
        child: Text('Event Detail Screen'),
      ),
    );
  }
}
