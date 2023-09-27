import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:respect/components/ht_button.dart';
import 'package:respect/constants.dart';
import 'package:respect/screen/sign_in_screen.dart';

class SignInSwitcherScreen extends StatelessWidget {
  const SignInSwitcherScreen({super.key});

  static String routeName = '/switcher';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              const SizedBox(
                height: 62,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(
                    "asset/logos/hypetown_logo_typo_with_symbol.png"),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "회원가입시 참가자 정보는 1회 만 입력하면 돼요 :)",
                    style: Constants.smallNormalTextStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  HTButton(
                    title: "비회원 접수",
                    titleColor: Constants.dark100,
                    backgroundColor: Constants.white,
                    strokeColor: Constants.dark100,
                    onPressed: () {
                      //TODO - 행사 디테일 화면 PUSH
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  HTButton(
                    title: "로그인 / 회원가입",
                    titleColor: Constants.white,
                    backgroundColor: Constants.dark100,
                    onPressed: () {
                      //TODO - 로그인 / 회원가입 화면
                      Navigator.of(context).pushNamed(SignInScreen.routeName);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
