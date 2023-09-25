// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:respect/main.dart';
import 'package:respect/utils/firebase_auth_services.dart';

void main() async {
  // test("description", () {
  //   Firebase.initializeApp();
  //   FirebaseAuthHelper.initializeFirebase();

  //   FirebaseAuthHelper.signUpWithPhoneNumber(
  //     phoneNumber: "01024405830",
  //     onVerificationCompleted: (userId) {},
  //     onCodeSent: (verificationId) {
  //       debugPrint(verificationId);
  //     },
  //     onVerificationFailed: (error) {
  //       debugPrint(error.message);
  //     },
  //     onCodeAutoRetrievalTimeout: (error) {
  //       debugPrint(error.characters.string);
  //     },
  //   );
  // });
}
