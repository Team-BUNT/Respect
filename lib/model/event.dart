import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  Event(
      {required this.id,
      required this.posterURL,
      required this.name,
      required this.province,
      required this.location,
      required this.date,
      this.dueDate,
      required this.type,
      required this.genre,
      this.account,
      this.link,
      this.detail,
      this.hostName,
      this.hostContact,
      this.isShowing});

  final String id;
  final String posterURL;
  final String name;
  final String province;
  final String location;
  final Timestamp date;
  final Timestamp? dueDate;
  final String type;
  final List<String> genre;
  final String? account;
  final String? link;
  final String? detail;
  final String? hostName;
  final String? hostContact;
  final bool? isShowing;

  factory Event.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Event(
      id: data?['id'],
      posterURL: data?['posterURL'],
      name: data?['name'],
      province: data?['province'],
      location: data?['location'],
      date: data?['date'],
      dueDate: data?['dueDate'],
      type: data?['type'],
      genre: data?['genre'],
      account: data?['account'],
      link: data?['link'],
      detail: data?['detail'],
      hostName: data?['hostName'],
      hostContact: data?['hostContact'],
      isShowing: data?['isShowing'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'posterURL': posterURL,
      'name': name,
      'province': province,
      'location': location,
      'date': date,
      'dueDate': dueDate,
      'type': type,
      'genre': genre,
      'account': account,
      'link': link,
      'detail': detail,
      'hostName': hostName,
      'hostContact': hostContact,
      'isShowing': isShowing,
    };
  }
}
