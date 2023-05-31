import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  Event(
      {required this.id,
      this.thumbnail,
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
      this.form,
      this.detail,
      this.hostName,
      this.hostContact,
      this.isShowing});

  final String id;
  final String? thumbnail;
  final String posterURL;
  final String name;
  final String province;
  final String location;
  final DateTime date;
  final DateTime? dueDate;
  final String type;
  final List<String> genre;
  final String? account;
  final String? link;
  final DocumentReference? form;
  final String? detail;
  final String? hostName;
  final String? hostContact;
  final bool? isShowing;

  Event.fromFirestore(Map<String, Object?> json)
      : this(
          id: json['id'] as String,
          thumbnail: json['thumbnail'] as String,
          posterURL: json['posterURL'] as String,
          name: json['name'] as String,
          province: json['province'] as String,
          location: json['location'] as String,
          date: json['date'] as DateTime,
          dueDate: json['dueDate'] as DateTime,
          type: json['type'] as String,
          genre: json['genre'] as List<String>,
          account: json['account'] as String,
          link: json['link'] as String,
          form: json['form'] as DocumentReference,
          detail: json['detail'] as String,
          hostName: json['hostName'] as String,
          hostContact: json['hostContact'] as String,
          isShowing: json['isShowing'] as bool,
        );

  Map<String, Object?> toFirestore() {
    return {
      'id': id,
      'thumbnail': thumbnail,
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
      'form': form,
      'detail': detail,
      'hostName': hostName,
      'hostContact': hostContact,
      'isShowing': isShowing,
    };
  }
}
