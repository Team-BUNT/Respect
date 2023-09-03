import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:respect/components/host_info_list_tile.dart';
import 'package:respect/constants.dart';
import 'package:respect/screen/apply_event_screen.dart';
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
  final DanceEvent event;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isLoading = false;
  bool showCTA = false;
  final scrollController = ScrollController();
  double previousScrollPosition = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final scrollController = ScrollController();
    scrollController.addListener(() {
      double currentScrollPosition = scrollController.position.pixels;
      if (currentScrollPosition > previousScrollPosition) {
        // Scrolling down
        if (currentScrollPosition > 200) {
          setState(() {
            showCTA = true;
          });
        }
      } else {
        // Scrolling up
        if (currentScrollPosition > 200) {
          return;
        } else {
          setState(() {
            showCTA = false;
          });
        }
      }
      previousScrollPosition = currentScrollPosition;
    });
  }

  KakaotalkSharingUtil kakaotalkSharingUtil = KakaotalkSharingUtil();

  Future<void> shareToKakao() async {
    final response = await http.get(Uri.parse(widget.event.posterURL ?? ""));
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(response.bodyBytes);

    await kakaotalkSharingUtil.shareToKakaotalk(
      image: file,
      name: widget.event.title ?? "",
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
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(widget.event.posterURL ?? ""),
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
                                'D-${int.parse(widget.event.date!.toDate().difference(DateTime.now()).inDays.toString() ?? "")}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      widget.event.type ?? "타입",
                                      style: eventDetailTypeTextStyle,
                                    ),
                                    labelPadding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    backgroundColor: eventTypeChipColor,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Wrap(
                                    spacing: 8,
                                    children: List.generate(
                                      widget.event.genres?.length ?? 0,
                                      (index) {
                                        return Chip(
                                          label: Text(
                                            widget.event.genres?[index] ?? "",
                                            style: eventDetailGenreTextStyle,
                                          ),
                                          labelPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          backgroundColor: genreChipColor,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                            widget.event.title ?? "행사 명",
                            style: eventDetailNameTextStyle,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            DateFormat('yyyy.MM.dd').format(
                              widget.event.date!.toDate(),
                            ),
                            style: eventDetailDateTextStyle,
                          ),
                        ],
                      ),
                    ),

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
                          eventInfoRow(
                              title: '장소', content: widget.event.place ?? ""),
                          const SizedBox(height: 16.0),
                          eventInfoRow(
                              title: '신청기한',
                              content:
                                  '${DateFormat('yyyy.MM.dd HH:mm').format(widget.event.ticketCloseDate!.toDate())} 까지'),
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
                          ListView.builder(
                              itemCount: widget.event.hostInfos?.length ?? 0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final hostInfo = widget.event.hostInfos?[index];
                                if (hostInfo != null) {
                                  return HostInfoListTile(
                                    profileUrl: hostInfo.imageUrl ?? "",
                                    role: hostInfo.role ?? "",
                                    name: hostInfo.name ?? "",
                                    instaUrl:
                                        'https://www.instagram.com/${hostInfo.instagramId}/',
                                  );
                                }
                                return null;
                              })
                        ],
                      ),
                    ),

                    const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '행사 개요',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            widget.event.subTitle ?? "",
                            style: const TextStyle(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '행사 상세정보',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            widget.event.detail ?? "",
                            style: const TextStyle(
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
                    const SizedBox(height: 120.0),
                    //TODO: Apply Button
                    // if (widget.event.entryLink != null ||
                    //     widget.event.entryLink != null)
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //     child: CupertinoButton(
                    //       color: Colors.black,
                    //       padding: const EdgeInsets.all(20.0),
                    //       onPressed: () async {
                    //         final url = Uri.parse(widget.event.entryLink!);

                    //         if (await canLaunchUrl(url)) {
                    //           launchUrl(url);
                    //         }
                    //       },
                    //       child: const Text(
                    //         '신청하기',
                    //         style: TextStyle(
                    //           fontSize: 17,
                    //           fontWeight: FontWeight.w600,
                    //           color: Color(0xFFFFFFFF),
                    //           fontFamily: 'Pretendard',
                    //         ),
                    //       ),
                    //     ),
                    //   )
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                bottom: showCTA
                    ? 0.0
                    : -120.0, // Adjust the bottom offset as needed
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.grey.shade100,
                  child: CupertinoButton(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 40, top: 12),
                    onPressed: () async {
                      if (widget.event.entryLink != null) {
                        debugPrint("구글 폼 링크 오픈");
                        final url = Uri.parse(widget.event.entryLink!);
                        if (await canLaunchUrl(url)) {
                          launchUrl(url);
                        }
                      } else {
                        Navigator.pushNamed(
                          context,
                          ApplyEventScreen.routeName,
                          arguments: widget.event,
                        );
                        debugPrint("행사 접수 페이지 이동");
                        //TODO - 행사가 RESPECT HOST  에서 만들어졌는지 로직 추가 필요
                      }
                    },
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          '접수하기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
