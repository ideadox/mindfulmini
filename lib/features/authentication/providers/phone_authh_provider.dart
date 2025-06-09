import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/authentication/screens/verification_complete_dailog.dart';
import 'package:mindfulminis/injection/injection.dart';

import '../../signup/screens/create_account.dart';
import '../screens/phone_verification.dart';

class PhoneAuthhProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final navigationService = sl<GoRouter>();

  TextEditingController phoneNumerController = TextEditingController();
  String? countryCode;
  String? code;
  final bool _isLoading = false;
  String? error;
  bool get isLoading => _isLoading;
  String get phoneNumber => countryCode! + phoneNumerController.text.trim();
  String? verificationId;
  int? resendToken;
  List<TextEditingController?> otpControllers = [];

  Future<void> phoneAuthSubmit() async {
    try {
      sl<GoRouter>().pushNamed(CreateAccount.routeName);
      
      if (countryCode == null || phoneNumerController.text.isEmpty) {
        return;
      }
      // sl<GoRouter>().pushNamed(PhoneVerification.routeName);
      String phoneNumber = countryCode! + phoneNumerController.text.trim();
      startTimer();
      await firebaseAuth.verifyPhoneNumber(
        // autoRetrievedSmsCodeForTesting: '123456',
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final smsCode = credential.smsCode;
          if (smsCode != null) {
            fillOtpFields(smsCode);
          }
          final userCredential = await firebaseAuth.signInWithCredential(
            credential,
          );
          showVerificationDailog();
          if (userCredential.user != null) {
            if (userCredential.additionalUserInfo!.isNewUser) {}
          } else {
            error =
                'Something went wrong, Please restart verification process.';
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          error = e.message ?? 'Something went wrong';
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          this.resendToken = resendToken;
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
        forceResendingToken: resendToken,
      );
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Something went wrong';
    } catch (e) {
      error = 'Something went wrong, Please restart verification process.';
    }
  }

  Future<void> onPhoneAuthVerificationCodeSubmit() async {
    if (code == null) {
      return;
    }
    if (code!.length != 6) {
      return;
    }

    if (verificationId == null) {
      return;
    }

    SmartDialog.showLoading();

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code!,
      );
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        showVerificationDailog();
        if (userCredential.additionalUserInfo!.isNewUser) {}
      } else {
        error = 'Something went wrong, Please restart verification process.';
      }
    } on FirebaseAuthException catch (e) {
      error = e.message ?? '';
    } catch (e) {
      error = 'Something went wrong';
    } finally {
      SmartDialog.dismiss();
      notifyListeners();
    }
  }

  onCodeChanged() {
    if (error != null) {
      error = null;
      notifyListeners();
    }
  }

  void fillOtpFields(String code) {
    for (int i = 0; i < code.length && i < otpControllers.length; i++) {
      otpControllers[i]!.text = code[i];
    }
  }

  Timer? _timer;
  final int _startSeconds = 30;
  int leftSeconds = 0;

  void startTimer() {
    int secondsLeft = _startSeconds;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsLeft--;
      if (secondsLeft <= 0) {
        leftSeconds = secondsLeft;
        timer.cancel();
        notifyListeners();
      } else {
        leftSeconds = secondsLeft;
        notifyListeners();
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    startTimer();
  }

  String formatSeconds(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }
}

void showVerificationDailog() {
  SmartDialog.show(
    clickMaskDismiss: false,
    backType: SmartBackType.ignore,
    builder: (context) {
      return VerificationCompleteDailog();
    },
  );
}
