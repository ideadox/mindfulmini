import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/authentication/screens/verification_complete_dailog.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/features/profile/profile_data/profile_data.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/exceptions.dart';

import '../../../core/services/shared_prefs.dart';
import '../auth_data/auth_data.dart';
import '../screens/phone_verification.dart';

class PhoneAuthhProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final navigationService = sl<GoRouter>();
  final AuthData _authData = sl<AuthData>();
  final ProfileData _profileData = sl<ProfileData>();
  final SharedPrefs _sharedPrefs = sl<SharedPrefs>();

  TextEditingController phoneNumerController = TextEditingController();
  String? countryCode = '+91';
  String? code;
  final bool _isLoading = false;
  String? error;
  bool get isLoading => _isLoading;
  String get phoneNumber => countryCode! + phoneNumerController.text.trim();
  String? verificationId;
  int? resendToken;
  List<TextEditingController?> otpControllers = [];

  void resetError() {
    error = null;
  }

  Future<void> phoneAuthSubmit() async {
    try {
      resetError();
      if (countryCode == null || phoneNumerController.text.isEmpty) {
        return;
      }
      sl<GoRouter>().pushNamed(PhoneVerification.routeName);
      String phoneNumber = countryCode! + phoneNumerController.text.trim();
      startTimer();
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final smsCode = credential.smsCode;
            if (smsCode != null) {
              fillOtpFields(smsCode);
            }
            final userCredential = await firebaseAuth.signInWithCredential(
              credential,
            );

            if (userCredential.user != null) {
              final firebaseUser = userCredential.user!;
              final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

              // HttpService now gets tokens from Firebase SDK directly,
              // no need to manually save tokens.

              if (isNewUser) {
                log('📱 New phone user (auto-verified), creating backend user...');
                await _createBackendUser(firebaseUser, isAutoVerified: true);
              } else {
                log('📱 Existing phone user (auto-verified), ensuring backend user...');
                await _handleExistingPhoneUser(firebaseUser, isAutoVerified: true);
              }
            } else {
              error = 'Something went wrong, Please restart verification process.';
              notifyListeners();
            }
          } catch (e) {
            log('❌ Verification completed error: $e');
            error = 'Something went wrong. Please try again.';
            notifyListeners();
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
    resetError();
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
        final firebaseUser = userCredential.user!;
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        // HttpService now gets tokens from Firebase SDK directly,
        // no need to manually save tokens.

        if (isNewUser) {
          log('📱 New phone user detected, creating backend user...');
          SmartDialog.dismiss();
          await _createBackendUser(firebaseUser);
        } else {
          log('📱 Existing phone user detected, ensuring backend user...');
          SmartDialog.dismiss();
          await _handleExistingPhoneUser(firebaseUser);
        }
      } else {
        error = 'Something went wrong, Please restart verification process.';
      }
    } on FirebaseAuthException catch (e) {
      log('❌ Firebase auth error: ${e.toString()}');

      if (e.code == 'invalid-verification-code') {
        error = 'Incorrect code. Please recheck and enter the correct OTP.';
      } else {
        error = e.message ?? 'Something went wrong';
      }
    } catch (e) {
      log('❌ Phone auth error: $e');
      error = 'Something went wrong. Please try again.';
    } finally {
      SmartDialog.dismiss();
      notifyListeners();
    }
  }

  /// Create backend user for a new phone auth user
  Future<void> _createBackendUser(User firebaseUser, {bool isAutoVerified = false}) async {
    try {
      final phoneNumber = firebaseUser.phoneNumber ?? 'User';
      final userId = await _authData.createUser({
        "firebaseUid": firebaseUser.uid,
        "fullname": phoneNumber,
        "phone": firebaseUser.phoneNumber,
      });

      await _sharedPrefs.setUserId(userId);
      log('✅ New phone user created successfully${isAutoVerified ? ' (auto-verified)' : ''}');

      if (isAutoVerified) {
        showVerificationDailog();
      } else {
        navigationService.goNamed(KidName.routeName);
      }
    } on InvalidInputException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty ? e.message : 'Failed to create account. Please try again.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } on BadRequestException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty ? e.message : 'Invalid request. Please try again.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } on UnauthorisedException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty ? e.message : 'Authentication failed. Please try again.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } on FetchDataException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty ? e.message : 'Server error. Please try again later.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } on TimeoutException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty ? e.message : 'Request timed out. Please try again.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = 'Failed to create account. Please try again.';
      log('❌ Create user failed: $e');
      notifyListeners();
    }
  }

  /// Handle existing phone user sign-in
  Future<void> _handleExistingPhoneUser(User firebaseUser, {bool isAutoVerified = false}) async {
    // Try to create/verify backend user (idempotent – backend returns existing user)
    try {
      final phoneNumber = firebaseUser.phoneNumber ?? 'User';
      final userId = await _authData.createUser({
        "firebaseUid": firebaseUser.uid,
        "fullname": phoneNumber,
        "phone": firebaseUser.phoneNumber,
      });
      await _sharedPrefs.setUserId(userId);
      log('✅ Backend user verified${isAutoVerified ? ' (auto-verified)' : ''}');
    } on BadRequestException catch (e) {
      log('ℹ️ Backend user may already exist: ${e.message}');
    } on UnauthorisedException catch (e) {
      log('⚠️ Backend auth error during user creation: ${e.message}');
    } catch (e) {
      log('⚠️ Could not verify/create backend user: $e');
    }

    log('✅ Existing phone user signed in successfully');

    // Check if user has completed onboarding (has a profile)
    try {
      await _profileData.getUser();
      log('✅ Profile exists - navigating to home');
      navigationService.goNamed(TabView.routeName);
    } on ProfileNotFoundException {
      log('📝 No profile found - redirecting to onboarding');
      navigationService.goNamed(KidName.routeName);
    } catch (e) {
      log('⚠️ Error checking profile, redirecting to onboarding: $e');
      navigationService.goNamed(KidName.routeName);
    }
  }

  /// Rollback Firebase user creation if backend operations fail
  Future<void> _rollbackFirebaseUser(User? user) async {
    if (user != null) {
      try {
        await user.delete();
        log('✅ Firebase user rolled back successfully');
      } catch (e) {
        log('❌ Failed to rollback Firebase user: $e');
        try {
          await firebaseAuth.signOut();
        } catch (signOutError) {
          log('❌ Failed to sign out after rollback: $signOutError');
        }
      }
    }
  }

  onCodeChanged(String code) {
    log(code);
    if (error != null) {
      resetError();
    }

    notifyListeners();
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
