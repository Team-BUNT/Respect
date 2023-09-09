import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthHelper {
  // Firebase 초기화
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  //MARK: - 회원가입 관련

  // 전화번호로 회원가입
  static void signUpWithPhoneNumber({
    required String phoneNumber,
    required void Function(String userId)? onVerificationCompleted,
    required void Function(String verificationId)? onCodeSent,
    required void Function(FirebaseAuthException error)? onVerificationFailed,
    required void Function(String error)? onCodeAutoRetrievalTimeout,
  }) {
    try {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android 환경에서만 호출됨!! SMS 코드 신경쓸 필요없이 자동으로 로그인
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          onVerificationCompleted?.call(userCredential.user!.uid);
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed?.call(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent?.call(verificationId);
          // UI - 인증코드를 입력하는 화면을 보여주는 코드
          // Update the UI - 사용자가 코드를 입력할 때까지 기다려야함.
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          onCodeAutoRetrievalTimeout?.call(verificationId);
        },
      );
    } catch (e) {
      // 회원가입 또는 로그인 실패

      debugPrint(e.toString());
    }
  }

  static void signInWithPhoneNumberWithSmsCode(
    String verificationId,
    String smsCode,
    Function(UserCredential) onSuccess,
    // Function(FirebaseAuthException) onError,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      onSuccess(userCredential);
    } catch (e) {
      // onError(e);
      debugPrint(e.toString());
    }
  }

  // 회원가입 기능
  static Future<void> signUp(
    String email,
    String password,
    Function(User?) onSuccess,
    Function(String) onError,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess(userCredential.user);
    } catch (e) {
      onError(e.toString());
    }
  }

  // 로그인 기능
  static Future<void> signIn(
    String email,
    String password,
    Function(User?) onSuccess,
    Function(String) onError,
  ) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess(userCredential.user);
    } catch (e) {
      onError(e.toString());
    }
  }

  // 비밀번호 재설정
  static Future<void> resetPassword(
    String email,
    Function() onSuccess,
    Function(String) onError,
  ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  // 회원 탈퇴
  static Future<void> signOut(
    Function() onSuccess,
    Function(String) onError,
  ) async {
    try {
      await FirebaseAuth.instance.signOut();
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  // 사용자 정보 업로드
  static Future<void> uploadUserInfo(
    Map<String, dynamic> userInfo,
    Function() onSuccess,
    Function(String) onError,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 사용자 정보를 Firestore 또는 Realtime Database에 업로드하는 코드를 여기에 추가
        onSuccess();
      } else {
        onError("사용자가 로그인하지 않았습니다.");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  // 사용자 정보 수정
  static Future<void> updateUserInfo(
    Map<String, dynamic> newUserInfo,
    Function() onSuccess,
    Function(String) onError,
  ) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 사용자 정보를 수정하는 코드를 여기에 추가
        onSuccess();
      } else {
        onError("사용자가 로그인하지 않았습니다.");
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
