import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:respect/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/event.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({
    super.key,
    required this.event,
  });

  static String routeName = "/event_detail_screen";

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '행사정보',
          style: navTextStyle,
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.1,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Image.network(event.posterURL),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Chip(
                  label: Text(
                    event.type,
                    style: eventDetailTypeTextStyle,
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  backgroundColor: eventTypeChipColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(
                  width: 8,
                ),
                Wrap(
                  spacing: 8,
                  children: List.generate(event.genre.length, (index) {
                    return Chip(
                      label: Text(
                        event.genre[index],
                        style: eventDetailGenreTextStyle,
                      ),
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: genreChipColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }),
                ),
                const Spacer(),
                CupertinoButton(
                  padding: const EdgeInsets.all(0.0),
                  child: Icon(
                    CupertinoIcons.share,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  onPressed: () {
                    //TODO: share
                    print('share');
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text(
                  event.name,
                  style: eventDetailNameTextStyle,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  DateFormat('yyyy.MM.dd').format(
                    event.date.toDate(),
                  ),
                  style: eventDetailDateTextStyle,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          const Divider(
            thickness: 2.0,
            color: Color(0xFFF4F4F4),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 22.0,
                ),
                const Text(
                  '행사정보',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const SizedBox(
                      width: 70,
                      child: Text(
                        '장소',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7A7A7A),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2E2E2E),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                if ((event.dueDate != null))
                  Row(
                    children: [
                      const SizedBox(
                        width: 70,
                        child: Text(
                          '신청기한',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7A7A7A),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('yyyy.MM.dd').format(
                          (event.dueDate?.toDate() ?? DateTime.now()),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7A7A7A),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                if ((event.account != null))
                  Row(
                    children: [
                      const SizedBox(
                        width: 70,
                        child: Text(
                          '계좌 번호',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7A7A7A),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      Text(
                        event.account ?? '??',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2E2E2E),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          if ((event.detail != null))
            Container(
              color: const Color(0xFFF4F4F4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    const Text(
                      '추가 안내사항',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4D4D4D),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      event.detail ?? '??',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF2F2F2F),
                        fontFamily: 'Pretendard',
                      ),
                    )
                  ],
                ),
              ),
            ),
          const SizedBox(height: 36),
          if ((event.link != null))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoButton(
                color: Colors.black,
                padding: const EdgeInsets.all(20.0),
                onPressed: () async {
                  final url = Uri.parse(event.link ?? '');

                  if (await canLaunchUrl(url)) {
                    launchUrl(url);
                  }
                },
                child: const Text(
                  '신청하기',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
