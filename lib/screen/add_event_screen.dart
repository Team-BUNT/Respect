import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../constants.dart';
import '../model/calendar_date_picker2_config.dart';
import '../model/event.dart';
import '../model/event_genre.dart';
import '../model/event_type.dart';
import '../model/province.dart';
import '../utils/amazon_s3_util.dart';
import '../utils/dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  static String routeName = "/add_event_screen";

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  Uuid uuid = const Uuid();
  XFile? posterImage;
  String? name;
  Province province = Province.seoul;
  String? location;
  List<DateTime?> date = [DateTime.now()];
  List<DateTime?>? dueDate;
  EventType eventType = EventType.battle;
  List<String> genre = ['올장르'];
  String? account;
  List<String> formLinks = [];
  String formLink = '';
  String? detail;
  String? hostName;
  String? hostContact;

  final _formKey = GlobalKey<FormState>();
  final _nameTextFieldFocusNode = FocusNode();
  final _locationTextFieldNode = FocusNode();
  final _hostNameTextFieldNode = FocusNode();
  final _hostContactTextFieldNode = FocusNode();
  final _nameTextFieldController = TextEditingController();
  final _locationTextFieldController = TextEditingController();
  final _accountTextFieldController = TextEditingController();
  final _detailTextEditingController = TextEditingController();
  final _hostNameTextFieldController = TextEditingController();
  final _hostContactTextFieldController = TextEditingController();

  // ignore: unused_field
  bool _nameFieldError = false;
  String? _nameErrorText;
  // ignore: unused_field
  bool _locationFieldError = false;
  String? _locationErrorText;
  // ignore: unused_field
  bool _hostNameFieldError = false;
  String? _hostNameErrorText;
  // ignore: unused_field
  bool _hostContactFieldError = false;
  String? _hostContactErrorText;

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    const androidIdPlugin = AndroidId();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidId = await androidIdPlugin.getId();
      return androidId;
    }
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: false,
            onPressed: () {
              _getPhotoLibraryImage();
              Navigator.pop(context);
            },
            child: const Text('라이브러리에서 불러오기'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('취소하기'),
        ),
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('행사 등록'),
          content: const Column(
            children: [
              Text('관리자의 승인 후'),
              Text('업로드될 예정입니다'),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("확인"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        posterImage = pickedFile;
      });
    }
  }

  Future<List<FocusNode>> _checkFieldCondition() async {
    List<FocusNode> errorFields = [];

    if (_nameFieldError) {
      errorFields.add(_nameTextFieldFocusNode);
    } else {
      errorFields.remove(_nameTextFieldFocusNode);
    }

    if (_locationFieldError) {
      errorFields.add(_locationTextFieldNode);
    } else {
      errorFields.remove(_locationTextFieldNode);
    }

    if (_hostNameFieldError) {
      errorFields.add(_hostNameTextFieldNode);
    } else {
      errorFields.remove(_hostNameTextFieldNode);
    }

    if (_hostContactFieldError) {
      errorFields.add(_hostContactTextFieldNode);
    } else {
      errorFields.remove(_hostContactTextFieldNode);
    }

    return errorFields;
  }

  @override
  void dispose() {
    _nameTextFieldController.dispose();
    _locationTextFieldController.dispose();
    _accountTextFieldController.dispose();
    _detailTextEditingController.dispose();
    _hostNameTextFieldController.dispose();
    _hostContactTextFieldController.dispose();
    _nameTextFieldFocusNode.dispose();
    _locationTextFieldNode.dispose();
    _hostNameTextFieldNode.dispose();
    _hostContactTextFieldNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AmazonS3Util amazonS3Util = AmazonS3Util();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '행사 등록',
            style: navTextStyle,
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0.1,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          '포스터 이미지',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '(1:1.3 비율 권장)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF64747),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      child: CupertinoButton(
                        child: Column(
                          children: [
                            if (posterImage == null)
                              Container(
                                width: 146,
                                height: 192,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Color(0xFFF4F4F4),
                                ),
                                child: const Icon(
                                  CupertinoIcons.plus,
                                  color: Colors.black,
                                ),
                              )
                            else
                              Container(
                                width: 146,
                                height: 192,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Color(0xFFF4F4F4),
                                  image: DecorationImage(
                                      image: FileImage(File(posterImage!.path)),
                                      fit: BoxFit.cover),
                                ),
                              )
                          ],
                        ),
                        onPressed: () {
                          _showActionSheet(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const Row(
                      children: [
                        Text(
                          '행사 이름',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF64747),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _nameTextFieldController,
                      focusNode: _nameTextFieldFocusNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20.0),
                        hintText: 'ex. 2023 리스펙트 댄스 페스티벌',
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF969696),
                          fontFamily: 'Pretendard',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        errorText: _nameErrorText,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        suffixIcon:
                            _nameTextFieldController.text.isNotEmpty //엑스버튼
                                ? CupertinoButton(
                                    alignment: Alignment.centerRight,
                                    child: const Icon(
                                      CupertinoIcons.xmark_circle_fill,
                                      color: Color(0xFF8E8E93),
                                    ),
                                    onPressed: () {
                                      _nameTextFieldController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                      ),
                      onChanged: (text) {
                        setState(() {
                          name = text;
                          _nameFieldError = false;
                          _nameErrorText = null;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            _nameFieldError = true;
                            _nameErrorText = '행사 이름을 입력해 주세요';
                          });
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '지역',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF64747),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        PullDownButton(
                          itemBuilder: (context) {
                            var provinces = Province.values
                                .where((province) => province != Province.all);
                            return provinces.map((pro) {
                              return PullDownMenuItem.selectable(
                                onTap: () {
                                  setState(() {
                                    province = pro;
                                  });
                                },
                                title: pro.convertToString,
                              );
                            }).toList();
                          },
                          buttonBuilder: (context, showMenu) => CupertinoButton(
                            onPressed: showMenu,
                            padding: EdgeInsets.zero,
                            child: Chip(
                              label: Row(
                                children: [
                                  Text(
                                    province.convertToString,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF636366),
                                      fontFamily: 'Pretendard',
                                    ),
                                  ),
                                  const SizedBox(width: 6.0),
                                  const Icon(
                                    CupertinoIcons.chevron_down,
                                    color: Color(0xFF636366),
                                    size: 11.0,
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                side: const BorderSide(
                                    color: Color(0xFFE5E5EA), width: 1),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '행사 위치',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF64747),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _locationTextFieldController,
                      focusNode: _locationTextFieldNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20.0),
                        hintText: 'ex. 번트 아카데미 2F (포항시 남구 지곡로 00-00)',
                        hintMaxLines: 1,
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF969696),
                          fontFamily: 'Pretendard',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        errorText: _locationErrorText,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        suffixIcon:
                            _locationTextFieldController.text.isNotEmpty //엑스버튼
                                ? CupertinoButton(
                                    alignment: Alignment.centerRight,
                                    child: const Icon(
                                      CupertinoIcons.xmark_circle_fill,
                                      color: Color(0xFF8E8E93),
                                    ),
                                    onPressed: () {
                                      _locationTextFieldController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                      ),
                      onChanged: (text) {
                        setState(() {
                          location = text;
                          _locationFieldError = false;
                          _locationErrorText = null;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _locationFieldError = true;
                          _locationErrorText = '행사 위치를 입력해 주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '행사 날짜',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF64747),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 113,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: const Color(0xFFF4F4F4),
                          ),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              DateFormat('MMM dd, yyyy')
                                  .format(date.first ?? DateTime.now()),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            onPressed: () async {
                              var selectedDate =
                                  await showCalendarDatePicker2Dialog(
                                context: context,
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                  controlsTextStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF000000),
                                    fontFamily: 'Pretendard',
                                  ),
                                  weekdayLabels: [
                                    'SUN',
                                    'Mon',
                                    'TUE',
                                    'WED',
                                    'THU',
                                    'FRI',
                                    'SAT'
                                  ],
                                  weekdayLabelTextStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0x4D3C3C43),
                                    fontFamily: 'Pretendard',
                                  ),
                                  dayTextStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily: 'Pretendard',
                                  ),
                                  selectedDayHighlightColor: Colors.black,
                                  selectedDayTextStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Pretendard',
                                  ),
                                  gapBetweenCalendarAndButtons: 0.0,
                                ),
                                dialogSize: const Size(343, 349),
                                value: date,
                                borderRadius: BorderRadius.circular(13),
                              );
                              setState(() {
                                if (selectedDate != null) {
                                  setState(() {
                                    date = selectedDate;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '신청 마감 날짜',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 113,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: const Color(0xFFF4F4F4),
                          ),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Text(
                              (dueDate != null)
                                  ? DateFormat('MMM dd, yyyy')
                                      .format(dueDate?.first ?? DateTime.now())
                                  : '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            onPressed: () async {
                              var selectedDate =
                                  await showCalendarDatePicker2Dialog(
                                context: context,
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                  controlsTextStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF000000),
                                    fontFamily: 'Pretendard',
                                  ),
                                  weekdayLabels: [
                                    'SUN',
                                    'Mon',
                                    'TUE',
                                    'WED',
                                    'THU',
                                    'FRI',
                                    'SAT'
                                  ],
                                  weekdayLabelTextStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0x4D3C3C43),
                                    fontFamily: 'Pretendard',
                                  ),
                                  dayTextStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily: 'Pretendard',
                                  ),
                                  selectedDayHighlightColor: Colors.black,
                                  selectedDayTextStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontFamily: 'Pretendard',
                                  ),
                                  gapBetweenCalendarAndButtons: 0.0,
                                ),
                                dialogSize: const Size(343, 349),
                                value: dueDate ?? [],
                                borderRadius: BorderRadius.circular(13),
                              );
                              setState(() {
                                if (selectedDate != null) {
                                  setState(() {
                                    dueDate = selectedDate;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        if (dueDate != null)
                          Container(
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: const Color(0xFFF4F4F4),
                            ),
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Text(
                                '삭제',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF535353),
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  dueDate = null;
                                });
                              },
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '행사 타입',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF64747),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        PullDownButton(
                          itemBuilder: (context) {
                            var types = EventType.values
                                .where((type) => type != EventType.all);
                            return types.map((type) {
                              return PullDownMenuItem.selectable(
                                onTap: () {
                                  setState(() {
                                    eventType = type;
                                  });
                                },
                                title: type.convertToString,
                              );
                            }).toList();
                          },
                          buttonBuilder: (context, showMenu) => CupertinoButton(
                            onPressed: showMenu,
                            padding: EdgeInsets.zero,
                            child: Chip(
                              label: Row(
                                children: [
                                  Text(
                                    eventType.convertToString,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF636366),
                                      fontFamily: 'Pretendard',
                                    ),
                                  ),
                                  const SizedBox(width: 6.0),
                                  const Icon(
                                    CupertinoIcons.chevron_down,
                                    color: Color(0xFF636366),
                                    size: 11.0,
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                side: const BorderSide(
                                    color: Color(0xFFE5E5EA), width: 1),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '장르',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF64747),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '중복 가능',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF636366),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        spacing: 12,
                        children: EventGenre.values
                            .where((genre) => genre != EventGenre.all)
                            .map((gen) {
                          return CupertinoButton(
                            padding: const EdgeInsets.all(0.0),
                            child: Chip(
                              label: Text(
                                gen.convertToString,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: (genre.contains(gen.convertToString))
                                      ? Colors.white
                                      : const Color(0xFF636366),
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                side: BorderSide(
                                    color: (genre.contains(gen.convertToString))
                                        ? Colors.black
                                        : const Color(0xFFE1E1E1),
                                    width: 1),
                              ),
                              backgroundColor:
                                  (genre.contains(gen.convertToString))
                                      ? Colors.black
                                      : Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (genre.contains(gen.convertToString)) {
                                  genre.remove(gen.convertToString);
                                } else {
                                  genre.add(gen.convertToString);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '계좌 번호',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _accountTextFieldController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20.0),
                        hintText: 'ex. 0000000000000 카카오뱅크 홍길동',
                        hintMaxLines: 1,
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF969696),
                          fontFamily: 'Pretendard',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        suffixIcon:
                            _accountTextFieldController.text.isNotEmpty //엑스버튼
                                ? CupertinoButton(
                                    alignment: Alignment.centerRight,
                                    child: const Icon(
                                      CupertinoIcons.xmark_circle_fill,
                                      color: Color(0xFF8E8E93),
                                    ),
                                    onPressed: () {
                                      _accountTextFieldController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                      ),
                      onChanged: (text) {
                        setState(() {
                          account = text;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '신청폼 선택',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    PullDownButton(
                      itemBuilder: (context) => formLinks.map((link) {
                        return PullDownMenuItem.selectable(
                          onTap: () {
                            setState(() {
                              formLink = link;
                            });
                          },
                          title: link,
                        );
                      }).toList(),
                      buttonBuilder: (context, showMenu) => CupertinoButton(
                        onPressed: showMenu,
                        padding: EdgeInsets.zero,
                        child: Chip(
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Row(
                              children: [
                                Text(
                                  formLink,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF636366),
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                const Spacer(),
                                Image.asset(
                                  'asset/icons/selectFormArrow.png',
                                  width: 16.0,
                                  height: 10.0,
                                )
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: const BorderSide(
                                color: Color(0xFFE5E5EA), width: 2),
                          ),
                          backgroundColor: const Color(0xFFF4F4F4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '상세 정보',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: _detailTextEditingController,
                      cursorColor: Colors.black,
                      maxLines: 15,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20.0),
                        hintText:
                            'MC, JUDGE, RULE, 상금, 주최, 문의 등 추가적인 정보를 입력해주세요.',
                        hintMaxLines: 15,
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF969696),
                          fontFamily: 'Pretendard',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          detail = text;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFE2E2E2)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          '* 아래 정보는 행사 정보에 업로드 되지 않으며,',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF626262),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          '   추가적인 정보 확인이 필요한 경우 사용됩니다.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF626262),
                            fontFamily: 'Pretendard',
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '등록자 명',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF64747),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _hostNameTextFieldController,
                      focusNode: _hostNameTextFieldNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20.0),
                        hintText: 'ex. OO크루, OO(댄서네임), OOO지자체',
                        hintMaxLines: 1,
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF969696),
                          fontFamily: 'Pretendard',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        errorText: _hostNameErrorText,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        suffixIcon:
                            _hostNameTextFieldController.text.isNotEmpty //엑스버튼
                                ? CupertinoButton(
                                    alignment: Alignment.centerRight,
                                    child: const Icon(
                                      CupertinoIcons.xmark_circle_fill,
                                      color: Color(0xFF8E8E93),
                                    ),
                                    onPressed: () {
                                      _hostNameTextFieldController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                      ),
                      onChanged: (text) {
                        setState(() {
                          hostName = text;
                          _hostNameFieldError = false;
                          _hostNameErrorText = null;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _hostNameFieldError = true;
                          _hostNameErrorText = '등록자 명을 입력해 주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 27.0),
                    const Row(
                      children: [
                        Text(
                          '등록자 연락처',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF64747),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _hostContactTextFieldController,
                      focusNode: _hostContactTextFieldNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20.0),
                        hintText: 'ex. 000-0000-0000 또는 youremail@gmail.com',
                        hintMaxLines: 1,
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF969696),
                          fontFamily: 'Pretendard',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F4F4),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        errorText: _hostContactErrorText,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        suffixIcon: _hostContactTextFieldController
                                .text.isNotEmpty //엑스버튼
                            ? CupertinoButton(
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: Color(0xFF8E8E93),
                                ),
                                onPressed: () {
                                  _hostContactTextFieldController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                      onChanged: (text) {
                        setState(() {
                          hostContact = text;
                          _hostContactFieldError = false;
                          _hostContactErrorText = null;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          _hostContactFieldError = true;
                          _hostContactErrorText = '등록자 연락처를 입력해 주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32.0),
                    CupertinoButton(
                      color: Colors.black,
                      padding: const EdgeInsets.all(20.0),
                      onPressed: () async {
                        _formKey.currentState!.validate();

                        if (_nameFieldError ||
                            _locationFieldError ||
                            _hostNameFieldError ||
                            _hostContactFieldError ||
                            posterImage == null) {
                          const snackBar = SnackBar(
                            content: Text('필수 항목을 모두 입력해 주세요'),
                            backgroundColor: Colors.black,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        } else {
                          final eventsRef = FirebaseFirestore.instance
                              .collection('events')
                              .withConverter<Event>(
                                fromFirestore: (snapshot, _) =>
                                    Event.fromFirestore(snapshot.data()!),
                                toFirestore: (event, _) => event.toFirestore(),
                              );

                          final id = uuid.v1();
                          final originImage = decodeImage(
                              File(posterImage?.path ?? '').readAsBytesSync());
                          final thumbImage =
                              copyResize(originImage!, width: 600);
                          final resizedImage =
                              copyResize(originImage, width: 1170);

                          final thumbnail = await amazonS3Util.uploadImage(
                              image: File('$name/thumbnail.png')
                                ..writeAsBytesSync(encodePng(thumbImage)),
                              name: name ?? '');
                          final posterURL = await amazonS3Util.uploadImage(
                              image: File('$name/poster.png')
                                ..writeAsBytesSync(encodePng(resizedImage)),
                              name: name ?? '');

                          await eventsRef.add(
                            Event(
                              id: id,
                              thumbnail: thumbnail,
                              posterURL: posterURL,
                              name: name ?? '??',
                              province: province.convertToString,
                              location: location ?? '??',
                              date: date.first ?? DateTime.now(),
                              type: eventType.convertToString,
                              genre: genre,
                              account: account,
                              formLink: formLink,
                              detail: detail,
                              hostName: hostName,
                              hostContact: hostContact,
                              isShowing: false,
                            ),
                          );
                          if (context.mounted) _showAlert(context);
                        }

                        var errorFields = await _checkFieldCondition();
                        if (errorFields.isNotEmpty) {
                          errorFields.first.requestFocus();
                        }
                      },
                      child: const Row(
                        children: [
                          Spacer(),
                          Text(
                            '등록하기',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
