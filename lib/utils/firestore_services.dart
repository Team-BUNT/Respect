import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../model/event.dart';

class FirestoreService {
  // static final enrollment
  static final db = FirebaseFirestore.instance;
  static final entryRef = db.collection('Entries');
  static final eventsRef = db.collection('Events');

  static Future<List<DanceEvent>> getAllDanceEvents() async {
    debugPrint("FIRESTORE: getAllDanceEventsBy");
    try {
      QuerySnapshot querySnapshot = await eventsRef.get();
      debugPrint("FIRESTORE: ${querySnapshot.docs.length}");
      List<DanceEvent> danceEvents = [];
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> danceEventMap =
            docSnapshot.data() as Map<String, dynamic>;

        // 서브컬렉션 데이터 가져오기
        List<TicketOption> ticketOptions = [];
        List<HostInfo> hostInfos = [];

        // MARK: - 티켓 옵션 서브 컬렉션 가져오기
        if (danceEventMap.containsKey('ticketOptions')) {
          QuerySnapshot ticketOptionsSnapshot =
              await docSnapshot.reference.collection("ticketOptions").get();
          for (var ticketOptionDoc in ticketOptionsSnapshot.docs) {
            Map<String, dynamic> ticketOptionMap =
                ticketOptionDoc.data() as Map<String, dynamic>;
            TicketOption ticketOption = TicketOption.fromJson(ticketOptionMap);
            ticketOptions.add(ticketOption);
          }
        }

        if (danceEventMap.containsKey('hostInfos')) {
          // MARK: - 주최자 정보 서브 컬렉션 가져오기
          QuerySnapshot hostInfosSnapshot =
              await docSnapshot.reference.collection("hostInfos").get();
          for (var hostInfoDoc in hostInfosSnapshot.docs) {
            Map<String, dynamic> json =
                hostInfoDoc.data() as Map<String, dynamic>;
            HostInfo hostInfo = HostInfo.fromJson(json);
            hostInfos.add(hostInfo);
          }
        }

        DanceEvent danceEvent = DanceEvent(
          id: danceEventMap['id'],
          provinance: danceEventMap['provinance'],
          posterURL: danceEventMap['posterURL'],
          thumbnailURL: danceEventMap['thumbnailURL'],
          createdAt: DateTime.parse(danceEventMap['createdAt']),
          totalCapacity: danceEventMap['totalCapacity'],
          isShowing: danceEventMap['isShowing'],
          paymentAgent: danceEventMap['paymentAgent'],
          title: danceEventMap['title'],
          place: danceEventMap['place'],
          date: DateTime.parse(danceEventMap['date']),
          ticketOpenDate: DateTime.parse(danceEventMap['ticketOpenDate']),
          ticketCloseDate: DateTime.parse(danceEventMap['ticketCloseDate']),
          type: danceEventMap['type'],
          detail: danceEventMap['detail'],
          genres: danceEventMap['genres'] != null
              ? List<String>.from(danceEventMap['genres'])
              : null,
          hostID: danceEventMap['hostID'],
          hostName: danceEventMap['hostName'],
          hostContact: danceEventMap['hostContact'],
          hostInquiryUrl: danceEventMap['hostInquiryUrl'],
          ticketOptions: ticketOptions,
          hostInfos: hostInfos,
          subTitle: danceEventMap['subTitle'],
        );

        danceEvents.add(danceEvent);
      }

      return danceEvents;
    } catch (e) {
      print("Error getting DanceEvents from Firestore: $e");
      rethrow;
    }
  }

  // static final

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getStreamWith(
  //     String eventID) {
  //   debugPrint("FIRESTORE: getStreamWithEventID");
  //   return entryRef
  //       .orderBy('enrolledAt', descending: true)
  //       .where("eventID", isEqualTo: eventID)
  //       .snapshots();
  // }

  static addEvent(DanceEvent event) async {
    await eventsRef.add(event.toJson());
    debugPrint("FIRESTORE: addEvent");
  }

  // static Future<void> uploadEventData(DanceEvent event) async {
  //   // 문서 추가 및 서브컬렉션 추가를 위한 트랜잭션 실행
  //   print("FIRESTORE: uploadEventData");
  //   await db.runTransaction(
  //     (transaction) async {
  //       // DanceEvent 객체를 Map으로 변환
  //       Map<String, dynamic> danceEventMap = event.toJson();

  //       // "danceEvents" 컬렉션에 새 문서 추가
  //       DocumentReference newDocRef = eventsRef.doc();
  //       transaction.set(newDocRef, danceEventMap);

  //       if (event.ticketOptions != null) {
  //         // "ticketOptions" 서브컬렉션 추가
  //         CollectionReference ticketOptionsCollection =
  //             newDocRef.collection("ticketOptions");
  //         for (TicketOption ticketOption in event.ticketOptions!) {
  //           Map<String, dynamic> ticketOptionMap = {
  //             'id': ticketOption.id,
  //             'title': ticketOption.title,
  //             'price': ticketOption.price,
  //             'capacity': ticketOption.capacity,
  //           };
  //           await ticketOptionsCollection.add(ticketOptionMap);
  //         }
  //       }

  //       if (event.hostInfos != null) {
  //         // "hostInfos" 서브컬렉션 추가
  //         CollectionReference hostInfosCollection =
  //             newDocRef.collection("hostInfos");
  //         for (HostInfo? hostInfo in event.hostInfos!) {
  //           Map<String, dynamic> hostInfoMap = {
  //             'name': hostInfo?.name,
  //             'role': hostInfo?.role,
  //             'instagramId': hostInfo?.instagramId,
  //             'imageUrl': hostInfo?.imageUrl,
  //           };
  //           await hostInfosCollection.add(hostInfoMap);
  //         }
  //       }
  //     },
  //   );
  // }

  static Future<DanceEvent> getDanceEvent(String docId) async {
    print("FIRESTORE: getDanceEvent");
    try {
      DocumentSnapshot docSnapshot = await eventsRef.doc(docId).get();

      if (docSnapshot.exists) {
        Map<String, dynamic> danceEventMap =
            docSnapshot.data() as Map<String, dynamic>;

        List<TicketOption> ticketOptions = [];
        List<HostInfo> hostInfos = [];

        // MARK: - 티켓 옵션 서브 컬렉션 가져오기
        if (danceEventMap.containsKey('ticketOptions')) {
          QuerySnapshot ticketOptionsSnapshot =
              await docSnapshot.reference.collection("ticketOptions").get();
          for (var ticketOptionDoc in ticketOptionsSnapshot.docs) {
            Map<String, dynamic> ticketOptionMap =
                ticketOptionDoc.data() as Map<String, dynamic>;
            TicketOption ticketOption = TicketOption.fromJson(ticketOptionMap);
            ticketOptions.add(ticketOption);
          }
        }

        if (danceEventMap.containsKey('hostInfos')) {
          // MARK: 주최자 정보 서브 컬렉션 가져오기
          QuerySnapshot hostInfosSnapshot =
              await docSnapshot.reference.collection("hostInfos").get();
          for (var hostInfoDoc in hostInfosSnapshot.docs) {
            Map<String, dynamic> hostInfoMap =
                hostInfoDoc.data() as Map<String, dynamic>;
            HostInfo hostInfo = HostInfo(
              name: hostInfoMap['name'],
              role: hostInfoMap['role'],
              instagramId: hostInfoMap['instagramId'],
              imageUrl: hostInfoMap['imageUrl'],
            );
            hostInfos.add(hostInfo);
          }
        }

        DanceEvent danceEvent = DanceEvent(
          id: danceEventMap['id'],
          provinance: danceEventMap['provinance'],
          posterURL: danceEventMap['posterURL'],
          thumbnailURL: danceEventMap['thumbnailURL'],
          createdAt: DateTime.parse(danceEventMap['createdAt']),
          totalCapacity: danceEventMap['totalCapacity'],
          isShowing: danceEventMap['isShowing'],
          paymentAgent: danceEventMap['paymentAgent'],
          title: danceEventMap['title'],
          place: danceEventMap['place'],
          date: DateTime.parse(danceEventMap['date']),
          ticketOpenDate: DateTime.parse(danceEventMap['ticketOpenDate']),
          ticketCloseDate: DateTime.parse(danceEventMap['ticketCloseDate']),
          type: danceEventMap['type'],
          detail: danceEventMap['detail'],
          genres: danceEventMap['genres'] != null
              ? List<String>.from(danceEventMap['genres'])
              : null,
          hostID: danceEventMap['hostID'],
          hostName: danceEventMap['hostName'],
          hostContact: danceEventMap['hostContact'],
          hostInquiryUrl: danceEventMap['hostInquiryUrl'],
          ticketOptions: ticketOptions,
          hostInfos: hostInfos,
          subTitle: danceEventMap['subTitle'],
        );

        return danceEvent;
      } else {
        throw Exception("Document not found");
      }
    } catch (e) {
      print("Error getting DanceEvent from Firestore: $e");
      rethrow;
    }
  }

  // static Future<void> uploadDanceEventWithSubcollection() async {
  //   try {
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     // DanceEvent 및 TestModel 객체 생성
  //     DanceEvent danceEvent = DanceEvent(
  //       // ... (필드 값 설정)
  //     );

  //     // 문서 추가 및 서브컬렉션 추가를 위한 트랜잭션 실행
  //     await firestore.runTransaction((transaction) async {
  //       // DanceEvent 객체를 Map으로 변환
  //       Map<String, dynamic> danceEventMap = danceEvent.toJson();

  //       // "danceEvents" 컬렉션에 새 문서 추가
  //       CollectionReference danceEventsCollection = firestore.collection("danceEvents");
  //       DocumentReference newDocRef = danceEventsCollection.doc();
  //       await transaction.set(newDocRef, danceEventMap);

  //       // "subcollection_name" 서브컬렉션 추가
  //       CollectionReference ticketOptionsSubcollection = newDocRef.collection("ticketOptions");

  //       // TestModel 객체를 Map으로 변환하여 서브컬렉션에 추가
  //       for (TestModel testModel in danceEvent.list) {
  //         Map<String, dynamic> testModelMap = {
  //           'id': testModel.id,
  //           'title': testModel.title,
  //         };
  //         await ticketOptionsSubcollection.add(testModelMap);
  //       }
  //     });

  //     print("DanceEvent with subcollection uploaded successfully!");
  //   } catch (e) {
  //     print("Error uploading DanceEvent with subcollection: $e");
  //   }
  // }
}
