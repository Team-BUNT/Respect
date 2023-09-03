import 'package:flutter/foundation.dart';
import 'package:respect/model/event.dart';
import 'package:respect/model/event_genre.dart';
import 'package:respect/model/province.dart';
import 'package:respect/utils/firestore_services.dart';

class EventsViewModel extends ChangeNotifier {
  List<DanceEvent> _eventList = [];
  List<DanceEvent> get eventList => _eventList;

  List<DanceEvent> _filteredEventList = [];
  List<DanceEvent> get filteredEventList => _filteredEventList;

  int currentEventTypeIndex = 0;
  Province selectedProvince = Province.all;
  EventGenre selectedGenre = EventGenre.all;

  Future<void> fetchData() async {
    try {
      debugPrint("DEBUG: getEvents $eventList");
      _eventList = await FirestoreService.getAllDanceEvents();
    } catch (error) {
      debugPrint("error: $error");
    }
    if (filteredEventList.isEmpty) {
      _filteredEventList = eventList;
    }
    notifyListeners();
  }

  void retrievEvents() async {
    eventList.clear();
    await fetchData();
    filterEvent();
  }

  void filterEvent() {
    if (filteredEventList.isEmpty) {
      _filteredEventList = eventList;
    }

    switch (currentEventTypeIndex) {
      case 1:
        _filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('배틀'),
            )
            .toList();
      case 2:
        _filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('퍼포먼스'),
            )
            .toList();
      case 3:
        _filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('워크샵'),
            )
            .toList();
      case 4:
        _filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('파티'),
            )
            .toList();
      case 5:
        _filteredEventList = filteredEventList
            .where(
              (event) => event.type!.startsWith('기타'),
            )
            .toList();
    }

    if (selectedProvince != Province.all) {
      _filteredEventList = filteredEventList
          .where(
            (event) =>
                event.provinance!.startsWith(selectedProvince.convertToString),
          )
          .toList();
    }

    if (selectedGenre != EventGenre.all) {
      _filteredEventList = filteredEventList
          .where(
            (event) => event.genres!.contains(selectedGenre.convertToString),
          )
          .toList();
    }
    notifyListeners();
  }
}
