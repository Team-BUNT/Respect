import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:respect/constants.dart';
import 'package:respect/screen/apply_form_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../model/event.dart';
import '../utils/kakao_util.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({
    super.key,
    required this.event,
  });

  static String routeName = '/event_detail_screen';

  final Event event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    KakaotalkSharingUtil kakaotalkSharingUtil = KakaotalkSharingUtil();

    return Stack(
      children: [
        Scaffold(
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
              Stack(children: [
                Image.network(widget.event.posterURL),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                        color: dDayChipColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(6.0)),
                    child: Text(
                      'D-${int.parse(widget.event.date.difference(DateTime.now()).inDays.toString())}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Chip(
                      label: Text(
                        widget.event.type,
                        style: eventDetailTypeTextStyle,
                      ),
                      labelPadding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
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
                      children:
                          List.generate(widget.event.genre.length, (index) {
                        return Chip(
                          label: Text(
                            widget.event.genre[index],
                            style: eventDetailGenreTextStyle,
                          ),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          backgroundColor: genreChipColor,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        final response = await http.get(Uri.parse(
                            widget.event.thumbnail ?? widget.event.posterURL));
                        final tempDir = await getTemporaryDirectory();
                        File file =
                            await File('${tempDir.path}/image.png').create();
                        file.writeAsBytesSync(response.bodyBytes);

                        await kakaotalkSharingUtil.shareToKakaotalk(
                          image: file,
                          name: widget.event.name,
                        );
                        setState(() {
                          isLoading = false;
                        });
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
                      widget.event.name,
                      style: eventDetailNameTextStyle,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      DateFormat('yyyy.MM.dd').format(
                        widget.event.date,
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
                            widget.event.location,
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
                    if (widget.event.dueDate != null)
                      const SizedBox(height: 16.0),
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
                            (widget.event.dueDate ?? DateTime.now()),
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
                    if (widget.event.account != null)
                      Column(
                        children: [
                          const SizedBox(height: 16.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              Expanded(
                                child: Text(
                                  widget.event.account ?? '??',
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
                        ],
                      )
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              if (widget.event.detail != null)
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
                          widget.event.detail ?? '??',
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
              if (widget.event.link != null || widget.event.form != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CupertinoButton(
                    color: Colors.black,
                    padding: const EdgeInsets.all(20.0),
                    onPressed: () async {
                      if (widget.event.form != null) {
                        Navigator.pushNamed(
                          context,
                          ApplyFormScreen.routeName,
                          arguments: ApplyFormScreenArguments(
                              isAdmin: false,
                              applyFormDocument: widget.event.form ?? ''),
                        );
                      } else {
                        final url = Uri.parse(widget.event.link!);

                        if (await canLaunchUrl(url)) {
                          launchUrl(url);
                        }
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
        ),
        if (isLoading)
          Center(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: SpinKitRotatingCircle(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset('asset/icons/respectIcon.png');
                },
              ),
            ),
          )
      ],
    );
  }
}
