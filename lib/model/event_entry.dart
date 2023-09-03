import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EventEntry {
  final String? eventID, paymentMethod, ticketOption;
  final Timestamp? enrolledAt;
  final String? id, name, dancerName, contact;
  final bool? paymentStatus;
  final String? paymentID;

  EventEntry({
    required this.eventID,
    required this.ticketOption,
    required this.paymentMethod,
    required this.id,
    required this.name,
    required this.dancerName,
    required this.contact,
    required this.enrolledAt,
    this.paymentStatus,
    this.paymentID,
  });

  EventEntry.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        eventID = json['eventID'] as String?,
        ticketOption = json['ticketOption'] as String?,
        paymentMethod = json['paymentMethod'] as String?,
        paymentID = json['paymentID'] as String?,
        paymentStatus = json['paymentStatus'] as bool?,
        name = json['name'] as String?,
        dancerName = json['dancerName'] as String?,
        contact = json['contact'] as String?,
        enrolledAt = json['enrolledAt'] as Timestamp?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'paymentID': paymentID,
        'ticketOption': ticketOption,
        'eventID': eventID,
        'dancerName': dancerName,
        'contact': contact,
        'enrolledAt': enrolledAt
      };

  List<dynamic> toRowData() {
    String? formattedEnrolledAt = enrolledAt?.toGeneralFormat();

    return [
      formattedEnrolledAt,
      name,
      dancerName,
      contact,
      ticketOption,
      paymentMethod,
      paymentStatus,
      id
    ];
  }

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
