import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:respect/model/apply_form.dart';

import '../constants.dart';

class MakeFormScreen extends StatefulWidget {
  const MakeFormScreen({super.key});

  static String routeName = '/make_form_screen';

  @override
  State<MakeFormScreen> createState() => _MakeFormScreenState();
}

class _MakeFormScreenState extends State<MakeFormScreen> {
  final formsRef =
      FirebaseFirestore.instance.collection('forms').withConverter<ApplyForm>(
            fromFirestore: (snapshot, _) =>
                ApplyForm.fromFirestore(snapshot.data()!),
            toFirestore: (event, _) => event.toFirestore(),
          );

  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    const androidIdPlugin = AndroidId();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidId = await androidIdPlugin.getId();
      return androidId;
    } else {
      return null;
    }
  }

  Future<void> _makeForm() async {
    final deviceId = await getDeviceId();
    await formsRef.add(ApplyForm(
      deviceId: deviceId ?? 'No Id',
      createAt: DateTime.now(),
      link: '',
      name: '',
    ));
  }

  final _formKey = GlobalKey<FormState>();
  String name = '';
  final _nameTextFieldFocusNode = FocusNode();
  final _nameTextFieldController = TextEditingController();
  bool _nameFieldError = false;
  String? _nameErrorText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '신청폼 생성',
            style: navTextStyle,
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0.1,
        ),
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
                          '행사 정보를 업로드 하기 전에, 신청폼을 생성하세요.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF636366),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 21.0),
                    const Row(
                      children: [
                        Text(
                          '신청폼 제목',
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
                    TextFormField(
                      controller: _nameTextFieldController,
                      focusNode: _nameTextFieldFocusNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20.0),
                        hintText: 'ex. 2023 리스펙트 댄스 페스티벌 신청폼',
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
                        suffixIcon: _nameTextFieldController.text.isNotEmpty
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
                            _nameErrorText = '신청폼 제목을 입력해 주세요';
                          });
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34.0),
              CupertinoButton(
                padding: const EdgeInsets.all(0.0),
                child: const Wrap(
                  children: [
                    Icon(
                      CupertinoIcons.add,
                      color: Color(0xFF636366),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      '질문 추가하기 ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF636366),
                        fontFamily: 'Pretendard',
                      ),
                      softWrap: true,
                    )
                  ],
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 30.0),
          child: CupertinoButton(
            color: Colors.black,
            padding: const EdgeInsets.all(20.0),
            onPressed: () {
              _formKey.currentState!.validate();
              // _makeForm();
            },
            child: const Row(
              children: [
                Spacer(),
                Text(
                  '신청폼 저장하기',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'Pretendard',
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
