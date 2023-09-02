import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:respect/components/host_info_list_tile.dart';
import 'package:respect/constants.dart';
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

  KakaotalkSharingUtil kakaotalkSharingUtil = KakaotalkSharingUtil();

  Future<void> shareToKakao() async {
    final response = await http
        .get(Uri.parse(widget.event.thumbnail ?? widget.event.posterURL));
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(response.bodyBytes);

    await kakaotalkSharingUtil.shareToKakaotalk(
      image: file,
      name: widget.event.name,
    );
  }

  Widget eventInfoRow({required String title, required String content}) {
    const infoStyle = TextStyle(
      color: Color(0xFF636366),
      fontSize: 15,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w500,
    );

    return Row(
      children: [
        SizedBox(
          width: 70.0,
          child: Text(title, style: infoStyle),
        ),
        const SizedBox(width: 4.0),
        Text(
          content,
          style: infoStyle.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Stack(
                children: [
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
                ],
              ),
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
                        setState(() => isLoading = true);
                        await shareToKakao();
                        setState(() => isLoading = false);
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
                    const SizedBox(height: 8.0),
                    Text(
                      DateFormat('yyyy.MM.dd').format(
                        widget.event.date,
                      ),
                      style: eventDetailDateTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    eventInfoRow(title: '장소', content: '서울특별시 광진구 동일로 100-100'),
                    const SizedBox(height: 16.0),
                    eventInfoRow(
                        title: '신청기한',
                        content:
                            '${DateFormat('yyyy.MM.dd').format(widget.event.date)} 까지'),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '주최자 정보',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    for (int i = 0; i < 3; i++)
                      const HostInfoListTile(
                        profileUrl:
                            'https://d2u3dcdbebyaiu.cloudfront.net/uploads/atch_img/724/2329af2ecf5f9b4dc8846a398dbd8635_res.jpeg',
                        role: 'MC',
                        name: 'Adrian',
                        instaUrl: 'https://www.instagram.com/yuns2_21/',
                      )
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '행사 개요',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '동해물과 백두산이 마르고 닳도록하느님이 보우하사',
                      style: TextStyle(
                        color: Color(0xFF636366),
                        fontSize: 15,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
              const SizedBox(height: 20.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '행사 개요',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      '1. 동해물과 백두산이 마르고 닳도록하느님이 보우하사\n우리나라 만세무궁화 삼천리 화려 강산 대한 사람\n대한으로 길이 보전하세 2. 남산 위에 저 소나무 철갑을\n두른 듯바람 서리 불변함은 우리 기상일세무궁화 삼천리\n화려 강산대한 사람 대한으로 길이 보전하세 \n3. 가을 하늘 공활한데 높고 구름 없이밝은 달은 우리 가슴\n일편단심일세무궁화 삼천리 화려 강산대한 사람 대한으로\n길이 보전하세4. 이 기상과 이 맘으로 충성을 다하여\n괴로우나 즐거우나 나라 사랑하세무궁화 삼천리 화려\n강산대한 사람 대한으로 길이 보전하세',
                      style: TextStyle(
                        color: Color(0xFF636366),
                        fontSize: 15,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.65,
                        letterSpacing: -0.10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              //TODO: Apply Button
              if (widget.event.link != null || widget.event.form != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CupertinoButton(
                    color: Colors.black,
                    padding: const EdgeInsets.all(20.0),
                    onPressed: () async {
                      if (widget.event.form != null) {
                        //TODO: Navigate to 행사 참가 신청 페이지
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
