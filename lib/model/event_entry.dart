import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventEntry {
  final String? eventID, eventName, paymentMethod, ticketOption;
  final Timestamp? enrolledAt, eventDate;
  final String? id, userID, name, dancerName, contact;
  final bool? paymentStatus;
  final String? paymentID;
  final int? price;

  EventEntry({
    required this.eventID,
    required this.eventName,
    required this.eventDate,
    required this.ticketOption,
    required this.paymentMethod,
    required this.id,
    required this.userID,
    required this.name,
    required this.price,
    required this.dancerName,
    required this.contact,
    required this.enrolledAt,
    this.paymentStatus,
    this.paymentID,
  });

  EventEntry.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        userID = json['userID'] as String?,
        eventID = json['eventID'] as String?,
        eventName = json['eventName'] as String?,
        eventDate = json['eventDate'] as Timestamp?,
        ticketOption = json['ticketOption'] as String?,
        paymentMethod = json['paymentMethod'] as String?,
        paymentID = json['paymentID'] as String?,
        price = json['price'] as int?,
        paymentStatus = json['paymentStatus'] as bool?,
        name = json['name'] as String?,
        dancerName = json['dancerName'] as String?,
        contact = json['contact'] as String?,
        enrolledAt = json['enrolledAt'] as Timestamp?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userID': userID,
        'name': name,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'paymentID': paymentID,
        'price': price,
        'ticketOption': ticketOption,
        'eventID': eventID,
        'eventName': eventName,
        'eventDate': eventDate,
        'dancerName': dancerName,
        'contact': contact,
        'enrolledAt': enrolledAt
      };

  @override
  bool operator ==(Object other) {
    return other is EventEntry && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

extension TimeStampExtension on Timestamp {
  String toGeneralFormat() {
    var dateTimeInstance = toDate();
    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTimeInstance);
    return formattedDateTime;
  }
}
