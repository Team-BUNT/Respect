import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthHelper {
  // Firebase 초기화
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  static final FirebaseAuth auth = FirebaseAuth.instance;

  //MARK: - 회원가입 관련

  // 전화번호로 회원가입
  static void signUpWithPhoneNumber({
    required String phoneNumber,
    required void Function(String userId)? verificationCompleted,
    required void Function(String verificationId, int? resendToken)? onCodeSent,
    required void Function(FirebaseAuthException error)? verificationFailed,
    required void Function(String error)? codeAutoRetrievalTimeout,
  }) {
    try {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android 환경에서만 호출됨!! SMS 코드 신경쓸 필요없이 자동으로 로그인
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          verificationCompleted?.call(userCredential.user!.uid);
        },
        verificationFailed: (FirebaseAuthException e) {
          verificationFailed?.call(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent?.call(verificationId, resendToken);
          // UI - 인증코드를 입력하는 화면을 보여주는 코드
          // Update the UI - 사용자가 코드를 입력할 때까지 기다려야함.
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          codeAutoRetrievalTimeout?.call(verificationId);
        },
      );
    } catch (e) {
      // 회원가입 또는 로그인 실패

      debugPrint(e.toString());
    }
  }

  // 전화번호로 로그인
  static Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required Function(User?) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String verificationId) codeAutoRetrievalTimeout,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 300),
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // MARK: - 안드로이드 ONLY
          await auth.signInWithCredential(credential);
          verificationCompleted(auth.currentUser);
        },
        verificationFailed: (FirebaseAuthException e) {
          verificationFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId, resendToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          codeAutoRetrievalTimeout(verificationId);
        },
      );
    } catch (e) {
      print("Sign In With Phone Number Error: $e");
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
