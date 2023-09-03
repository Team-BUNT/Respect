import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:respect/components/apply_text_field.dart';
import 'package:respect/components/checkbox_term_list_tile.dart';
import 'package:respect/components/event_info_row.dart';
import 'package:respect/constants.dart';
import 'package:respect/model/event.dart';
import 'package:respect/utils/firestore_services.dart';
import 'package:respect/utils/formatter.dart';

import '../model/event_entry.dart';

class ApplyEventScreen extends StatefulWidget {
  const ApplyEventScreen({super.key, required this.event});

  final DanceEvent event;
  static String routeName = '/apply_event_screen';

  @override
  State<ApplyEventScreen> createState() => _ApplyEventScreenState();
}

class _ApplyEventScreenState extends State<ApplyEventScreen> {
  TicketOption? selectedTicket;
  bool agreePrivacy = false;
  bool agreePurchase = false;

  void applyEvent() {
    final entryModel = EventEntry(
      id: UniqueKey().hashCode.toString(),
      enrolledAt: Timestamp.now(),
      eventID: widget.event.id,
      ticketOption: widget.event.ticketOptions?.first.title,
      paymentMethod: "접수",
      name: "전주완",
      dancerName: "WISE",
      contact: "01024405830",
    );

    FirestoreService.addEntry(entryModel);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '행사접수',
            style: navTextStyle,
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0.1,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            const SizedBox(height: 36.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.event.subTitle ?? '',
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
            const SizedBox(height: 24.0),
            const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '행사 정보',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  EventInfoRow(title: '장소', content: widget.event.place ?? ''),
                  const SizedBox(height: 16.0),
                  EventInfoRow(
                    title: '날짜',
                    content:
                        DateFormat('yyyy.MM.dd').format(widget.event.date!),
                  ),
                  const SizedBox(height: 16.0),
                  EventInfoRow(
                    title: '시간',
                    content: DateFormat('HH:mm').format(widget.event.date!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
            const SizedBox(height: 24.0),
            //MARK: -  티켓 선택
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '티켓 선택',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    '티켓을 선택해주세요.',
                    style: TextStyle(
                      color: Color(0xFF636366),
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.60,
                      letterSpacing: -0.10,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  for (TicketOption option in widget.event.ticketOptions ?? [])
                    Column(
                      children: [
                        tiketOptionButton(option),
                        const SizedBox(height: 16.0)
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '최종 접수 정보',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  if (selectedTicket != null)
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2.0,
                            color: Color(0xFFF2F2F7),
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedTicket?.title ?? '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 19,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.16,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Adrian',
                                        style: TextStyle(
                                          color: Colors.transparent,
                                          fontSize: 15,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'KRW ${Formatter.formatNumber(selectedTicket?.price ?? 0)}',
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                          height: 1.29,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Center(
                      child: Text(
                        '티켓을 선택해주세요.',
                        style: TextStyle(
                          color: Color(0xFF636366),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
            const SizedBox(height: 24.0),
            //MARK: - 참가자 수집 정보
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '참가자 수집 정보 (선택)',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    '입금자 정보',
                    style: TextStyle(
                      color: Color(0xFF636366),
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.47,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ApplyTextField(hintText: 'ex.홍길동(홍길동)'),
                  const SizedBox(height: 20.0),
                  const Text(
                    '인스타그램 ID',
                    style: TextStyle(
                      color: Color(0xFF636366),
                      fontSize: 15,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.47,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  ApplyTextField(hintText: 'ex.@djsg.dkf'),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            const Divider(thickness: 2.0, color: Color(0xFFF4F4F4)),
            const SizedBox(height: 24.0),
            //MARK: - 이용 약관 동의
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '이용 약관 동의',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  checkAllAgree(),
                  const SizedBox(height: 16.0),
                  CheckboxTermListTile(
                    value: agreePrivacy,
                    title: '제 3자 정보 이용 동의 (필수)',
                    onChanged: (newValue) {
                      setState(() => agreePrivacy = newValue!);
                    },
                  ),
                  const SizedBox(height: 4.0),
                  CheckboxTermListTile(
                    value: agreePurchase,
                    title: '티켓 구매 및 취소/환불규정 동의 (필수)',
                    onChanged: (newValue) {
                      setState(() => agreePurchase = newValue!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 54.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoButton(
                color: Colors.black,
                padding: const EdgeInsets.all(20.0),
                onPressed: () {
                  //TODO - 접수하기 로직 구현
                  applyEvent();
                  Navigator.pop(context);
                },
                child: const Text(
                  '접수하기',
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
    );
  }

  Widget tiketOptionButton(TicketOption option) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.5,
              color: selectedTicket == option
                  ? Colors.black
                  : const Color(0xFFCCCCCC),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 20.0,
                height: 20.0,
                decoration: const ShapeDecoration(
                  shape: CircleBorder(
                    side: BorderSide(width: 1.5, color: Colors.black),
                  ),
                ),
                child: Image.asset(
                  'asset/icons/checkmark_circle_fill.png',
                  width: 20.0,
                  height: 20.0,
                  color: selectedTicket == option ? null : Colors.transparent,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.title!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Adrian',
                          style: TextStyle(
                            color: Colors.transparent,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'KRW ${Formatter.formatNumber(option.price!)}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.47,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        setState(() => selectedTicket = option);
      },
    );
  }

  Widget checkAllAgree() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 1.0,
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color(0xFFCCCCCC),
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (agreePrivacy && agreePurchase)
                Image.asset(
                  'asset/icons/checkmark_circle_fill.png',
                  width: 20.0,
                  height: 20.0,
                )
              else
                Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(
                        side: BorderSide(color: Color(0xFFCCCCCC), width: 1.0),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 12.0),
              const Text(
                '전체동의',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        final newValue = (agreePrivacy && agreePurchase);

        setState(() {
          agreePrivacy = !newValue;
          agreePurchase = !newValue;
        });
      },
    );
  }
}
