import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:respect/components/event_info_row.dart';
import 'package:respect/model/event_entry.dart';
import 'package:respect/utils/firestore_services.dart';

import '../constants.dart';

class MyEntryScreen extends StatefulWidget {
  const MyEntryScreen({super.key});
  static String routeName = 'my_entry_screen';

  @override
  State<MyEntryScreen> createState() => _MyEntryScreenState();
}

class _MyEntryScreenState extends State<MyEntryScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "나의 내역",
          style: navTextStyle,
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image:
                              NetworkImage("https://via.placeholder.com/55x55"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '정윤성',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                            ),
                          ),
                          Text(
                            '010-2440-5830',
                            style: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 15,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              height: 1.47,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '접수 현황',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  FutureBuilder(
                    future: FirestoreService.getEventEntriesBy("NEIS1234"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final myEntries = snapshot.data;
                        if (myEntries != null) {
                          debugPrint("entry: ${myEntries.length}");
                          return ListView.builder(
                            itemCount: myEntries.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: MyEntryCard(
                                  entry: myEntries[index],
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text("신청 내역이 존재하지 않습니다."),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyEntryCard extends StatelessWidget {
  final EventEntry entry;

  const MyEntryCard({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0xFFE5E5EA),
          ),
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            entry.eventName ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          EventInfoRow(
            title: "행사 일시",
            content: DateFormat('yyyy.MM.dd HH:mm').format(
              entry.eventDate!.toDate(),
            ),
          ),
          const SizedBox(height: 8),
          EventInfoRow(
            title: "신청 일자",
            content: DateFormat('yyyy.MM.dd HH:mm').format(
              entry.enrolledAt!.toDate(),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: ShapeDecoration(
              color: const Color(0xFFF7F7F7),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  entry.ticketOption ?? "",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.29,
                  ),
                ),
                const Spacer(),
                Text(
                  '${NumberFormat('#,###').format(entry.price)}원',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.29,
                  ),
                )
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
