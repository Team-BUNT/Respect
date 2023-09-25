import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:respect/constants.dart';

import '../components/ht_button.dart';
import '../components/ht_dialog.dart';
import '../components/ht_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController controller = TextEditingController();
  bool isSend = false;
  bool isValidVerficationCode = false;
  bool isEditable = false;
  String phoneNumber = "";
  String verificationCode = "";
  int minutes = 5;
  int seconds = 00;
  late Timer timer;

  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //TODO - 전화번호 자동 입력
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로그인")),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                '안녕하세요! 🪩 \n다시 만나 반갑습니다.',
                style: TextStyle(
                  color: Color(0xFF1E232C),
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    flex: 200,
                    child: HTTextField(
                      controller: TextEditingController.fromValue(
                          TextEditingValue(
                              text: phoneNumber,
                              selection: TextSelection.collapsed(
                                  offset: phoneNumber.length))),
                      hintText: "010-0000-0000",
                      inputFormatters: [
                        PhoneNumberInputFormatter(),
                        TextInputFormatter.withFunction(
                            (oldValue, newValue) => convert(oldValue, newValue))
                      ],
                      keyboardType: TextInputType.phone,
                      onChanged: (newValue) {
                        setState(() {
                          isSend = false;
                          startTimer();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 130,
                    child: SizedBox(
                      height: 48,
                      child: HTButton(
                        title: isSend ? "인증번호 재발송" : "인증번호 발송",
                        titleColor: isSend ? Colors.black : Colors.white,
                        strokeColor: Colors.black,
                        backgroundColor: isSend ? Colors.white : Colors.black,
                        onPressed: () {
                          // TODO - 인증번호 발송 기능

                          const dialog = HTDialog(
                            message: "인증번호가 전송되었습니다.",
                            primaryLabel: "확인",
                          );
                          showAlertDialog(context, dialog: dialog);
                          setState(() {
                            isSend = true;
                            startTimer();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              if (isSend)
                Row(
                  children: [
                    Expanded(
                      flex: 200,
                      child: HTTextField(
                        hintText: "인증번호",
                        keyboardType: TextInputType.number,

                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        // error: !isValidVerficationCode,
                        // errorText: "*인증번호가 일치하지 않습니다.",

                        // onChanged: (newValue) =>
                        //     _onNumberChanged(newValue, user?.email ?? ""),
                        onSubmitted: (p0) {
                          debugPrint("submitted - $p0");
                        },
                        suffixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${minutes.toString().padLeft(1, "0")}:${seconds.toString().padLeft(2, "0")}",
                              style: const TextStyle(
                                color: Color(0xFF555555),
                                fontSize: 14,
                                fontFamily: 'Spoqa Han Sans Neo',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(width: 12),
                    // Expanded(
                    //   flex: 130,
                    //   child: SizedBox(
                    //     height: 48,
                    //     child: HTButton(
                    //       title: "인증번호 확인",
                    //       titleColor: Colors.white,
                    //       backgroundColor: Colors.black,
                    //       onPressed: () {
                    //         //TODO - 인증번호 확인 기능
                    //         setState(() {
                    //           isValidVerficationCode = true;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              const Spacer(),
              HTButton(
                title: "완료",
                titleColor: isSend ? Colors.white : const Color(0xFF555555),
                backgroundColor: Colors.black,
                onPressed: (!isSend) ? null : handleEditButtonTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void didVerficationCodeSendButtonPressed() {
    setState(() {
      isSend = false;
    });

    String cleanedPhoneNumber = phoneNumber.replaceAll('-', '');

    const dialog = HTDialog(
      message: "인증번호가 전송되었습니다.",
      primaryLabel: "확인",
    );
    showAlertDialog(context, dialog: dialog);
    startTimer();
    setState(() {
      isSend = true;
    });
  }

  void handleEditButtonTap() {}

  void showAlertDialog(BuildContext context, {required HTDialog dialog}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void toggle(bool data) {
    data = !data;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (minutes == 0 && seconds == 0) {
          timer.cancel();
          isSend = false;
          minutes = 5;
        } else if (seconds == 0) {
          minutes--;
          seconds = 59;
        } else {
          seconds--;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  convert(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.length == 11) {
      // The below code gives a range error if not 10.
      RegExp phone = RegExp(r'(\d{3})(\d{4})(\d{4})');
      var matches = phone.allMatches(newValue.text);
      if (matches.isNotEmpty) {
        var match = matches.elementAt(0);
        newText = '${match.group(1)}-${match.group(2)}-${match.group(3)}';
      }
    }

    setState(() {
      phoneNumber = newText;
    });

    return TextEditingValue(
      text: newText,
      selection: TextSelection(
          baseOffset: newValue.text.length, extentOffset: newValue.text.length),
    );
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 입력된 텍스트에서 숫자와 하이픈만 필터링하여 남기고 나머지 문자 제거
    final filteredText = newValue.text.replaceAll(RegExp(r'[^0-9-]'), '');

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}
