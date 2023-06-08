import 'dart:async';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:respect/components/form_field_card.dart';
import 'package:respect/model/apply_form.dart';
import 'package:respect/model/form_field_template.dart';
import 'package:respect/utils/form_builder.dart';
import '../constants.dart';

class MakeFormScreen extends StatefulWidget {
  const MakeFormScreen({super.key, required this.onDismiss});

  static String routeName = '/make_form_screen';

  final Function() onDismiss;

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

  Future<void> _makeForm(List<FormFieldTemplate> fieldList) async {
    final deviceId = await getDeviceId();

    await formsRef.doc('${deviceId}_$name').set(
          ApplyForm(
            deviceId: deviceId ?? 'No Id',
            createAt: DateTime.now(),
            //TODO: 스프레드시트 링크 추가
            link: '스프레드시트 링크',
            name: name,
          ),
        );

    for (FormFieldTemplate field in fieldList) {
      await formsRef.doc('${deviceId}_$name').collection('formFields').add({
        'index': fieldList.indexOf(field),
        'type': field.type.convertToString,
        'title': field.title,
        'shortText': '',
        'longText': '',
        'options': (field.type == FormFieldType.multiple) ? field.options : '',
        'selectedOption': '',
        'checkBoxes':
            (field.type == FormFieldType.checkBox) ? field.checkBoxes : '',
        'selectedBoxes': [],
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  String name = '';
  final _nameTextFieldFocusNode = FocusNode();
  final _nameTextFieldController = TextEditingController();
  // ignore: unused_field
  bool _nameFieldError = false;
  String? _nameErrorText;

  @override
  void initState() {
    Future.microtask(() {
      context.read<FormBuilder>().resetFormField();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FormBuilder>(
      builder: (context, formBuilder, child) {
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
                        const SizedBox(height: 20),
                        const Divider(),
                        formBuilder.formFieldList.isNotEmpty
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: formBuilder.formFieldList.length,
                                itemBuilder: (context, index) {
                                  return FormFieldCard(
                                    key: UniqueKey(),
                                    isEditingMode: true,
                                    fieldIndex: index,
                                    formFieldTemplate:
                                        formBuilder.formFieldList[index],
                                  );
                                },
                              )
                            : const Text('')
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
                    onPressed: () {
                      setState(() {
                        context.read<FormBuilder>().addFormField();
                      });
                    },
                  ),
                  const SizedBox(height: 100.0),
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
                  if (_nameFieldError) {
                    const snackBar = SnackBar(
                      content: Text('필수 항목을 모두 입력해 주세요'),
                      backgroundColor: Colors.black,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    _nameTextFieldFocusNode.requestFocus();
                  } else {
                    _makeForm(formBuilder.formFieldList);
                    Navigator.pop(context);
                    widget.onDismiss();
                  }
                },
                child: const Row(
                  children: [
                    Spacer(),
                    Text(
                      '저장하기',
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
      },
    );
  }
}
