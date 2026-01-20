import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/authentication/screens/verification_complete_dailog.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:mindfulminis/services/exceptions.dart';

import '../../../services/shared_prefs.dart';
import '../../../services/storage/token_storage.dart';
import '../auth_data/auth_data.dart';
import '../screens/phone_verification.dart';

class PhoneAuthhProvider with ChangeNotifier {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final navigationService = sl<GoRouter>();
  final AuthData _authData = sl<AuthData>();
  final SharedPrefs _sharedPrefs = sl<SharedPrefs>();
  final TokenStorage _tokenStorage = sl<TokenStorage>();

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
      // sl<GoRouter>().pushNamed(PhoneVerification.routeName);
      // return;
      resetError();
      if (countryCode == null || phoneNumerController.text.isEmpty) {
        return;
      }
      sl<GoRouter>().pushNamed(PhoneVerification.routeName);
      String phoneNumber = countryCode! + phoneNumerController.text.trim();
      startTimer();
      await firebaseAuth.verifyPhoneNumber(
        // autoRetrievedSmsCodeForTesting: '123456',
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

              // Get Firebase token
              final token = await firebaseUser.getIdToken(true);
              if (token == null || token.isEmpty) {
                error = 'Failed to get authentication token. Please try again.';
                notifyListeners();
                return;
              }

              if (isNewUser) {
                // New user: Create backend user
                log('📱 New phone user (auto-verified), creating backend user...');
                try {
                  // Use phone number as placeholder name - user will update during onboarding
                  final phoneNumber = firebaseUser.phoneNumber ?? 'User';
                  final userId = await _authData.createUser({
                    "firebaseUid": firebaseUser.uid,
                    "fullname": phoneNumber, // Placeholder - will be updated during onboarding
                  });

                  await _sharedPrefs.setUserId(userId);
                  await _tokenStorage.saveAccessToken(token);
                  log('✅ New phone user created successfully (auto-verified)');

                  // Show verification dialog and navigate
                  showVerificationDailog();
                } on InvalidInputException catch (e) {
                  await _rollbackFirebaseUser(firebaseUser);
                  error = e.message.isNotEmpty ? e.message : 'Failed to create account. Please try again.';
                  log('❌ Create user failed (auto-verified): ${e.message}');
                  notifyListeners();
                } on BadRequestException catch (e) {
                  await _rollbackFirebaseUser(firebaseUser);
                  error = e.message.isNotEmpty ? e.message : 'Invalid request. Please try again.';
                  log('❌ Create user failed (auto-verified): ${e.message}');
                  notifyListeners();
                } on UnauthorisedException catch (e) {
                  await _rollbackFirebaseUser(firebaseUser);
                  error = e.message.isNotEmpty ? e.message : 'Authentication failed. Please try again.';
                  log('❌ Create user failed (auto-verified): ${e.message}');
                  notifyListeners();
                } on FetchDataException catch (e) {
                  await _rollbackFirebaseUser(firebaseUser);
                  error = e.message.isNotEmpty ? e.message : 'Server error. Please try again later.';
                  log('❌ Create user failed (auto-verified): ${e.message}');
                  notifyListeners();
                } on TimeoutException catch (e) {
                  await _rollbackFirebaseUser(firebaseUser);
                  error = e.message.isNotEmpty ? e.message : 'Request timed out. Please try again.';
                  log('❌ Create user failed (auto-verified): ${e.message}');
                  notifyListeners();
                } catch (e) {
                  await _rollbackFirebaseUser(firebaseUser);
                  error = 'Failed to create account. Please try again.';
                  log('❌ Create user failed (auto-verified): $e');
                  notifyListeners();
                }
              } else {
                // Existing user: Ensure backend user exists
                log('📱 Existing phone user (auto-verified), ensuring backend user exists...');
                await _tokenStorage.saveAccessToken(token);
                
                // Try to create backend user if it doesn't exist
                try {
                  // Use phone number as placeholder name - user will update during onboarding
                  final phoneNumber = firebaseUser.phoneNumber ?? 'User';
                  final userId = await _authData.createUser({
                    "firebaseUid": firebaseUser.uid,
                    "fullname": phoneNumber, // Placeholder - will be updated during onboarding
                  });
                  await _sharedPrefs.setUserId(userId);
                  log('✅ Backend user created/verified for existing phone user (auto-verified)');
                } on BadRequestException catch (e) {
                  // User might already exist (e.g., duplicate firebaseUid) - that's okay
                  log('ℹ️ Backend user may already exist (auto-verified): ${e.message}');
                  // Continue - profile fetch will handle getting the userId
                } on UnauthorisedException catch (e) {
                  // Auth error - but we just got a valid token, so this might be a backend issue
                  // Continue anyway - let profile fetch handle it
                  log('⚠️ Backend auth error during user creation (auto-verified): ${e.message}');
                } catch (e) {
                  // Any other error - log but continue
                  log('⚠️ Could not verify/create backend user (auto-verified): $e');
                  // Continue - profile fetch will determine if user exists
                }

                log('✅ Existing phone user signed in successfully (auto-verified)');

                // Navigate directly to home for existing users
                navigationService.goNamed(TabView.routeName);
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

    User? firebaseUser;
    bool isNewUser = false;

    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code!,
      );
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        firebaseUser = userCredential.user;
        isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        // Step 1: Get Firebase token
        final token = await firebaseUser!.getIdToken(true);
        if (token == null || token.isEmpty) {
          throw Exception('Failed to get authentication token from Firebase');
        }

        // Step 2: Handle new vs existing users
        if (isNewUser) {
          // New user: Create backend user
          log('📱 New phone user detected, creating backend user...');
          try {
            // Use phone number as placeholder name - user will update during onboarding
            final phoneNumber = firebaseUser.phoneNumber ?? 'User';
            final userId = await _authData.createUser({
              "firebaseUid": firebaseUser.uid,
              "fullname": phoneNumber, // Placeholder - will be updated during onboarding
            });

            // Save user data and token
            await _sharedPrefs.setUserId(userId);
            await _tokenStorage.saveAccessToken(token);
            log('✅ New phone user created successfully');

            // Navigate to onboarding
            SmartDialog.dismiss();
            navigationService.goNamed(KidName.routeName);
          } on InvalidInputException catch (e) {
            await _rollbackFirebaseUser(firebaseUser);
            error = e.message.isNotEmpty ? e.message : 'Failed to create account. Please try again.';
            log('❌ Create user failed: ${e.message}');
          } on BadRequestException catch (e) {
            await _rollbackFirebaseUser(firebaseUser);
            error = e.message.isNotEmpty ? e.message : 'Invalid request. Please try again.';
            log('❌ Create user failed: ${e.message}');
          } on UnauthorisedException catch (e) {
            await _rollbackFirebaseUser(firebaseUser);
            error = e.message.isNotEmpty ? e.message : 'Authentication failed. Please try again.';
            log('❌ Create user failed: ${e.message}');
          } on FetchDataException catch (e) {
            await _rollbackFirebaseUser(firebaseUser);
            error = e.message.isNotEmpty ? e.message : 'Server error. Please try again later.';
            log('❌ Create user failed: ${e.message}');
          } on TimeoutException catch (e) {
            await _rollbackFirebaseUser(firebaseUser);
            error = e.message.isNotEmpty ? e.message : 'Request timed out. Please try again.';
            log('❌ Create user failed: ${e.message}');
          } catch (e) {
            await _rollbackFirebaseUser(firebaseUser);
            error = 'Failed to create account. Please try again.';
            log('❌ Create user failed: $e');
          }
        } else {
          // Existing user: Ensure backend user exists
          log('📱 Existing phone user detected, ensuring backend user exists...');
          await _tokenStorage.saveAccessToken(token);
          
          // Try to create backend user if it doesn't exist
          // This is safe to call even if user already exists - backend should handle it gracefully
          try {
            // Use phone number as placeholder name - user will update during onboarding
            final phoneNumber = firebaseUser.phoneNumber ?? 'User';
            final userId = await _authData.createUser({
              "firebaseUid": firebaseUser.uid,
              "fullname": phoneNumber, // Placeholder - will be updated during onboarding
            });
            await _sharedPrefs.setUserId(userId);
            log('✅ Backend user created/verified for existing phone user');
          } on BadRequestException catch (e) {
            // User might already exist (e.g., duplicate firebaseUid) - that's okay
            // The backend should return the existing user or handle it gracefully
            log('ℹ️ Backend user may already exist: ${e.message}');
            // Continue - profile fetch will handle getting the userId
          } on UnauthorisedException catch (e) {
            // Auth error - but we just got a valid token, so this might be a backend issue
            // Continue anyway - let profile fetch handle it
            log('⚠️ Backend auth error during user creation: ${e.message}');
          } catch (e) {
            // Any other error - log but continue
            // User might already exist, or there might be a temporary backend issue
            log('⚠️ Could not verify/create backend user: $e');
            // Continue - profile fetch will determine if user exists
          }

          log('✅ Existing phone user signed in successfully');

          // Navigate to home
          SmartDialog.dismiss();
          navigationService.goNamed(TabView.routeName);
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

  /// Rollback Firebase user creation if backend operations fail
  Future<void> _rollbackFirebaseUser(User? user) async {
    if (user != null) {
      try {
        await user.delete();
        log('✅ Firebase user rolled back successfully');
      } catch (e) {
        log('❌ Failed to rollback Firebase user: $e');
        // If deletion fails, try to sign out at least
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
