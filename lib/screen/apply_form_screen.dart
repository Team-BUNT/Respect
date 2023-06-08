import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:respect/components/apply_field_card.dart';
import 'package:respect/model/form_field_template.dart';
import '../constants.dart';

class ApplyFormScreenArguments {
  final bool isAdmin;
  final String applyFormDocument;

  ApplyFormScreenArguments(
      {required this.isAdmin, required this.applyFormDocument});
}

class ApplyFormScreen extends StatefulWidget {
  const ApplyFormScreen({super.key, required this.args});

  static String routeName = '/apply_form_screen';

  final ApplyFormScreenArguments args;

  @override
  State<ApplyFormScreen> createState() => _ApplyFormScreenState();
}

class _ApplyFormScreenState extends State<ApplyFormScreen> {
  bool isLoading = false;
  String title = '';
  List<FormFieldTemplate> fieldList = [];

  Future getApplyForms() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('forms')
        .doc(widget.args.applyFormDocument)
        .get()
        .then(
      (snapshot) {
        setState(() {
          title = snapshot['name'];
        });
      },
    );
    await FirebaseFirestore.instance
        .collection('forms')
        .doc(widget.args.applyFormDocument)
        .collection('formFields')
        .orderBy('index')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        var document = doc.data();
        int index = document['index'];
        FormFieldType type =
            (document['type'] as String).convertToFormFieldType;
        String title = document['title'];
        String shortText = document['shortText'];
        String longText = document['longText'];
        List<String> options = List<String>.from(document['options']);
        String selectedOption = document['selectedOption'];
        List<String> checkBoxes = List<String>.from(document['checkBoxes']);
        List<String> selectedBoxes =
            List<String>.from(document['selectedBoxes']);

        FormFieldTemplate field = FormFieldTemplate(
          index: index,
          type: type,
          title: title,
          shortText: shortText,
          longText: longText,
          options: options,
          selectedOption: selectedOption,
          checkBoxes: checkBoxes,
          selectedBoxes: selectedBoxes,
        );
        setState(() {
          fieldList.add(field);
        });
      }
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getApplyForms();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '신청폼',
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
                  if (!isLoading)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                '한번 등록한 행사는 수정이 불가능하니 유의하여 작성해 주세요.',
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
                          Row(
                            children: [
                              Text(
                                '[ $title ]',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 21.0),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: fieldList.length,
                            itemBuilder: (context, index) {
                              return ApplyFieldCard(
                                key: UniqueKey(),
                                formFieldTemplate: fieldList[index],
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  const SizedBox(height: 34.0),
                ],
              ),
            ),
            bottomSheet: Stack(
              children: [
                if (!widget.args.isAdmin)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 30.0),
                    child: CupertinoButton(
                      color: Colors.black,
                      padding: const EdgeInsets.all(20.0),
                      onPressed: () {
                        _formKey.currentState!.validate();

                        bool isInvaild = false;
                        for (FormFieldTemplate field in fieldList) {
                          switch (field.type) {
                            case FormFieldType.short:
                              if (field.shortText == '') {
                                isInvaild = true;
                              }
                            case FormFieldType.long:
                              if (field.longText == '') {
                                isInvaild = true;
                              }
                            case FormFieldType.multiple:
                              if (field.selectedOption == '') {
                                isInvaild = true;
                              }
                            case FormFieldType.checkBox:
                              if (field.selectedBoxes == []) {
                                isInvaild = true;
                              }
                            default:
                              isInvaild = false;
                          }
                        }

                        if (isInvaild) {
                          const snackBar = SnackBar(
                            content: Text('항목을 모두 입력해 주세요'),
                            backgroundColor: Colors.black,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        } else {
                          //TODO: 스프레드시트 데이터 업로드
                          Navigator.pop(context);
                        }
                      },
                      child: const Row(
                        children: [
                          Spacer(),
                          Text(
                            '제출하기',
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
                  )
                  else
                  const SizedBox.shrink()
              ],
            ),
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
