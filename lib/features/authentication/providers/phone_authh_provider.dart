import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthhProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? verificationId;
  int? resendToken;
  Future<void> phoneAuthSubmit(phoneNumber) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        // autoRetrievedSmsCodeForTesting: '123456',
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await firebaseAuth.signInWithCredential(
            credential,
          );
          if (userCredential.user != null) {
            if (userCredential.additionalUserInfo!.isNewUser) {
              // await createUserUsecase(userCredential.user!);
            }

            //loading false;
          } else {
            //loading false errror
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // loading false error
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationId = verificationId;
          resendToken = resendToken;
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
        forceResendingToken: resendToken,
      );
    } catch (e) {
      //
    }
  }

  Future<void> onPhoneAuthVerificationCodeSubmit(String code) async {
    // emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          // await createUserUsecase(userCredential.user!);
        }

        // emit(
        //   state.copyWith(
        //     isLoading: false,
        //     success: true,
        //     errorMessage: null,
        //     userId: userCredential.user!.uid,
        //     verificationId: credential.verificationId,
        //   ),
        // );
      } else {
        // emit(
        //   state.copyWith(
        //     isLoading: false,
        //     errorMessage: 'User credential is null',
        //     verificationId: credential.verificationId,
        //   ),
        // );
      }
    } catch (e) {
      // emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void reset() {
    // emit(const PhoneAuthState());
  }
}
