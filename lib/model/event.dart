import 'package:cloud_firestore/cloud_firestore.dart';

class DanceEvent {
  final String? id;
  //MARK: - default setting
  final Timestamp? createdAt;
  final Timestamp? ticketOpenDate;
  final Timestamp? ticketCloseDate;
  final int? totalCapacity;
  final bool? isShowing;
  final bool? paymentAgent;

  //MARK: - subcollections
  final List<TicketOption>? ticketOptions;
  //MARK: - detail information
  final String? type;
  final String? title;
  final String? subTitle;
  final String? posterURL;
  final String? thumbnailURL;
  final String? place;

  final String? provinance;
  final Timestamp? date;
  final String? detail;
  final List<String>? genres;
  // HOST
  final String? hostID;
  final String? hostName;
  final String? hostContact;
  final String? hostInquiryUrl;
  final String? account;
  final String? entryLink; // 엔트리 링크
  //MARK: - subcollections
  final List<HostInfo?>? hostInfos;

  DanceEvent({
    required this.id,
    required this.provinance,
    required this.posterURL,
    required this.thumbnailURL,
    required this.createdAt,
    this.totalCapacity,
    this.isShowing,
    this.paymentAgent,
    this.hostID,
    this.hostName,
    this.hostContact,
    this.hostInquiryUrl,
    required this.title,
    required this.subTitle,
    required this.place,
    required this.date,
    this.ticketOpenDate,
    required this.ticketCloseDate,
    required this.type,
    required this.detail,
    this.genres,
    this.ticketOptions,
    this.hostInfos,
    this.account,
    this.entryLink,
  });

  factory DanceEvent.fromJson(Map<String, dynamic> json) {
    return DanceEvent(
      id: json['id'],
      provinance: json['provinance'],
      posterURL: json['posterURL'],
      thumbnailURL: json['thumbnailURL'],
      createdAt: json['createdAt'] as Timestamp?,
      ticketOpenDate: json['ticketOpenDate'] as Timestamp?,
      ticketCloseDate: json['ticketCloseDate'] as Timestamp?,
      totalCapacity: json['totalCapacity'],
      isShowing: json['isShowing'],
      paymentAgent: json['paymentAgent'],
      hostID: json['hostID'],
      hostName: json['hostName'],
      hostContact: json['hostContact'],
      hostInquiryUrl: json['hostInquiryUrl'],
      title: json['title'],
      place: json['place'],
      date: json['date'] as Timestamp?,
      type: json['type'],
      detail: json['detail'],
      genres: List<String>.from(json['genres'] ?? []),
      ticketOptions: (json['ticketOptions'] as List<dynamic>)
          .map((optionJson) => TicketOption.fromJson(optionJson))
          .toList(),
      hostInfos: (json['hostInfos'] as List<dynamic>)
          .map((infoJson) => HostInfo.fromJson(infoJson))
          .toList(),
      account: json['account'],
      entryLink: json['entryLink'],
      subTitle: json['subTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provinance': provinance,
      'posterURL': posterURL,
      'thumbnailURL': thumbnailURL,
      'createdAt': createdAt,
      'ticketOpenDate': ticketOpenDate,
      'ticketCloseDate': ticketCloseDate,
      'totalCapacity': totalCapacity,
      'isShowing': isShowing,
      'paymentAgent': paymentAgent,
      'hostID': hostID,
      'hostName': hostName,
      'hostContact': hostContact,
      'hostInquiryUrl': hostInquiryUrl,
      'title': title,
      'place': place,
      'date': date,
      'type': type,
      'detail': detail,
      'genres': genres,
      'ticketOptions': ticketOptions?.map((option) => option.toJson()).toList(),
      'hostInfos': hostInfos?.map((info) => info?.toJson()).toList(),
      'account': account,
      'entryLink': entryLink,
      'subTitle': subTitle,
    };
  }

  // factory DanceEvent.fromJson(Map<String, dynamic> json) {
  //   return DanceEvent(
  //     // ... (필드 설정은 여기에 포함)
  //     ticketOptions: (json['ticketOptions'] as List<dynamic>)
  //         .map((optionJson) => TicketOption.fromJson(optionJson))
  //         .toList(),
  //     hostInfos: (json['hostInfos'] as List<dynamic>)
  //         .map((infoJson) => HostInfo.fromJson(infoJson))
  //         .toList(),
  //   );
  // }
}

//MARK: - Ticket Option Subcollection
class TicketOption {
  final String? id;
  final String? title;
  final int? price;
  final int? capacity;

  TicketOption({
    this.id,
    this.title,
    this.price,
    this.capacity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'capacity': capacity,
    };
  }

  factory TicketOption.fromJson(Map<String, dynamic> json) {
    return TicketOption(
      id: json['id'],
      title: json['title'],
      price: json['price'] as int,
      capacity: json['capacity'] as int,
    );
  }
}

//MARK: - Host Information Subcollection
class HostInfo {
  final String? id;
  final String? name;
  final String? role;
  final String? instagramId;
  final String? imageUrl;

  HostInfo({
    this.id,
    this.name,
    this.role,
    this.imageUrl,
    this.instagramId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'instagramId': instagramId,
      'imageUrl': imageUrl,
    };
  }

  factory HostInfo.fromJson(Map<String, dynamic> json) {
    return HostInfo(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      instagramId: json['instagramId'],
      imageUrl: json['imageUrl'],
    );
  }
}


// class Event {
//   final String? id;
//   //MARK: - default setting
//   final DateTime? createdAt;
//   final String? posterURL;
//   final DateTime? ticketOpenDate;
//   final DateTime? ticketCloseDate;
//   final int? totalCapacity;
//   final bool? isShowing;
//   final bool? paymentAgent;
//   //MARK: - subcollections
//   final List<TicketOption>? ticketOptions;
//   //MARK: - detail information
//   final String? type;
//   final String? title;
//   final String? place;
//   final String? provinance;
//   final DateTime? date;
//   final String? detail;
//   final List<String>? genres;
//   // HOST
//   final String? hostID;
//   final String? hostName;
//   final String? hostContact;
//   final String? hostInquiryUrl;
//   //MARK: - subcollections
//   final List<HostInfo?>? hostInfos;

//   DanceEvent({
//     required this.id,
//     required this.provinance,
//     required this.posterURL,
//     required this.createdAt,
//     required this.totalCapacity,
//     this.isShowing,
//     this.paymentAgent,
//     this.hostID,
//     this.hostName,
//     this.hostContact,
//     this.hostInquiryUrl,
//     required this.title,
//     required this.place,
//     required this.date,
//     required this.ticketOpenDate,
//     required this.ticketCloseDate,
//     required this.type,
//     required this.detail,
//     this.genres,
//     this.ticketOptions,
//     this.hostInfos,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'provinance': provinance,
//       'posterURL': posterURL,
//       'createdAt': createdAt?.toIso8601String(),
//       'ticketOpenDate': ticketOpenDate?.toIso8601String(),
//       'ticketCloseDate': ticketCloseDate?.toIso8601String(),
//       'totalCapacity': totalCapacity,
//       'isShowing': isShowing,
//       'paymentAgent': paymentAgent,
//       'hostID': hostID,
//       'hostName': hostName,
//       'hostContact': hostContact,
//       'hostInquiryUrl': hostInquiryUrl,
//       'title': title,
//       'place': place,
//       'date': date?.toIso8601String(),
//       'type': type,
//       'detail': detail,
//       'genres': genres,
//       'ticketOptions': ticketOptions?.map((option) => option.toJson()).toList(),
//       'hostInfos': hostInfos?.map((info) => info?.toJson()).toList(),
//     };
//   }

//   // factory DanceEvent.fromJson(Map<String, dynamic> json) {
//   //   return DanceEvent(
//   //     // ... (필드 설정은 여기에 포함)
//   //     ticketOptions: (json['ticketOptions'] as List<dynamic>)
//   //         .map((optionJson) => TicketOption.fromJson(optionJson))
//   //         .toList(),
//   //     hostInfos: (json['hostInfos'] as List<dynamic>)
//   //         .map((infoJson) => HostInfo.fromJson(infoJson))
//   //         .toList(),
//   //   );
//   // }
// }

// //MARK: - Ticket Option Subcollection
// class TicketOption {
//   final String? id;
//   final String? title;
//   final int? price;
//   final int? capacity;

//   TicketOption({
//     this.id,
//     this.title,
//     this.price,
//     this.capacity,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'price': price,
//       'capacity': capacity,
//     };
//   }

//   factory TicketOption.fromJson(Map<String, dynamic> json) {
//     return TicketOption(
//       id: json['id'],
//       title: json['title'],
//       price: json['price'] as int,
//       capacity: json['capacity'] as int,
//     );
//   }
// }

// //MARK: - Host Information Subcollection
// class HostInfo {
//   final String? id;
//   final String? name;
//   final String? role;
//   final String? instagramId;
//   final String? imageUrl;

//   HostInfo({
//     this.id,
//     this.name,
//     this.role,
//     this.imageUrl,
//     this.instagramId,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'role': role,
//       'instagramId': instagramId,
//       'imageUrl': imageUrl,
//     };
//   }

//   factory HostInfo.fromJson(Map<String, dynamic> json) {
//     return HostInfo(
//       id: json['id'],
//       name: json['name'],
//       role: json['role'],
//       instagramId: json['instagramId'],
//       imageUrl: json['imageUrl'],
//     );
//   }
// }
