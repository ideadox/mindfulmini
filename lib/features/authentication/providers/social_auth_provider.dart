import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindfulminis/core/injection/injection.dart';
import 'package:mindfulminis/core/services/exceptions.dart';
import 'package:mindfulminis/features/authentication/auth_data/auth_data.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/features/profile/profile_data/profile_data.dart';
import 'package:mindfulminis/features/tab_view/screens/tab_view.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/services/shared_prefs.dart';

/// Handles Google and Apple OAuth sign-in.
///
/// Follows the same backend user-creation and profile-check navigation
/// pattern established by [PhoneAuthhProvider] and [CreateAccountProvoider].
class SocialAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _navigationService = sl<GoRouter>();
  final AuthData _authData = sl<AuthData>();
  final ProfileData _profileData = sl<ProfileData>();
  final SharedPrefs _sharedPrefs = sl<SharedPrefs>();

  bool isLoading = false;
  String? error;

  void resetError() {
    error = null;
  }

  // ── Google Sign-In ──────────────────────────────────────────────────

  /// Ensures [GoogleSignIn.instance.initialize] is called exactly once.
  bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_googleSignInInitialized) {
      await GoogleSignIn.instance.initialize();
      _googleSignInInitialized = true;
    }
  }

  Future<void> signInWithGoogle() async {
    resetError();
    try {
      isLoading = true;
      notifyListeners();

      // Initialize the Google Sign-In SDK (idempotent guard)
      await _ensureGoogleSignInInitialized();

      // Trigger the interactive Google Sign-In flow (v7 API)
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      // Obtain the idToken (sync getter in v7)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a Firebase credential using idToken only (v7 removed accessToken)
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final firebaseUser = userCredential.user!;
        final isNewUser =
            userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          log('🔵 New Google user, creating backend user...');
          await _createBackendUser(
            firebaseUser,
            fullname: googleUser.displayName ?? firebaseUser.displayName ?? 'User',
            email: googleUser.email,
          );
        } else {
          log('🔵 Existing Google user, ensuring backend user...');
          await _handleExistingUser(
            firebaseUser,
            fullname: googleUser.displayName ?? firebaseUser.displayName ?? 'User',
            email: googleUser.email,
          );
        }
      } else {
        error = 'Google sign-in failed. Please try again.';
      }
    } on GoogleSignInException catch (e) {
      // v7 throws GoogleSignInException on cancel/errors instead of returning null
      if (e.code == GoogleSignInExceptionCode.canceled) {
        log('ℹ️ Google sign-in cancelled by user');
      } else {
        log('❌ Google sign-in exception: ${e.code} - ${e.description}');
        error = 'Google sign-in failed. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      log('❌ Firebase auth error (Google): ${e.toString()}');
      error = e.message ?? 'Google sign-in failed. Please try again.';
    } catch (e) {
      log('❌ Google sign-in error: $e');
      error = 'Google sign-in failed. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Apple Sign-In ───────────────────────────────────────────────────

  Future<void> signInWithApple() async {
    resetError();
    try {
      isLoading = true;
      notifyListeners();

      // Generate a nonce for security
      final rawNonce = _generateNonce();
      final hashedNonce = _sha256ofString(rawNonce);

      // Request Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      if (appleCredential.identityToken == null) {
        error = 'Apple did not return an identity token. Please try again.';
        log('❌ Apple identityToken is null — cannot proceed');
        return;
      }

      // Create an OAuthCredential for Firebase
      // Note: some Firebase versions require accessToken (authorizationCode) alongside idToken
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase
      final userCredential =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        final firebaseUser = userCredential.user!;
        final isNewUser =
            userCredential.additionalUserInfo?.isNewUser ?? false;

        // Apple only provides name on the FIRST sign-in. After that,
        // givenName / familyName will be null. We build the best name
        // we can and fallback to the Firebase display name or email.
        final appleName = _buildAppleName(
          givenName: appleCredential.givenName,
          familyName: appleCredential.familyName,
        );
        final fullname = appleName ??
            firebaseUser.displayName ??
            firebaseUser.email ??
            'User';

        // If Apple provided a name and Firebase doesn't have one, update it
        if (appleName != null &&
            (firebaseUser.displayName == null ||
                firebaseUser.displayName!.isEmpty)) {
          try {
            await firebaseUser.updateDisplayName(appleName);
          } catch (e) {
            log('⚠️ Could not update Firebase display name: $e');
          }
        }

        if (isNewUser) {
          log('🍎 New Apple user, creating backend user...');
          await _createBackendUser(
            firebaseUser,
            fullname: fullname,
            email: appleCredential.email ?? firebaseUser.email,
          );
        } else {
          log('🍎 Existing Apple user, ensuring backend user...');
          await _handleExistingUser(
            firebaseUser,
            fullname: fullname,
            email: appleCredential.email ?? firebaseUser.email,
          );
        }
      } else {
        error = 'Apple sign-in failed. Please try again.';
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        log('ℹ️ Apple sign-in cancelled by user');
        // User cancelled – not an error
      } else {
        log('❌ Apple authorization error: ${e.message}');
        error = 'Apple sign-in failed. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      log('❌ Firebase auth error (Apple): ${e.toString()}');
      error = e.message ?? 'Apple sign-in failed. Please try again.';
    } catch (e) {
      log('❌ Apple sign-in error: $e');
      error = 'Apple sign-in failed. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Shared post-auth logic ──────────────────────────────────────────

  /// Create backend user for a new OAuth user.
  ///
  /// Mirrors [PhoneAuthhProvider._createBackendUser].
  Future<void> _createBackendUser(
    User firebaseUser, {
    required String fullname,
    String? email,
  }) async {
    try {
      final map = <String, dynamic>{
        "firebaseUid": firebaseUser.uid,
        "fullname": fullname,
      };
      if (email != null && email.trim().isNotEmpty) {
        map["email"] = email;
      }

      final userId = await _authData.createUser(map);
      await _sharedPrefs.setUserId(userId);
      log('✅ Backend user created for OAuth user');

      // New user → go to onboarding
      _navigationService.goNamed(KidName.routeName);
    } on InvalidInputException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty
          ? e.message
          : 'Failed to create account. Please try again.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } on BadRequestException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty
          ? e.message
          : 'Invalid request. Please try again.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } on UnauthorisedException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty
          ? e.message
          : 'Authentication failed. Please try again.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } on FetchDataException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty
          ? e.message
          : 'Server error. Please try again later.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } on TimeoutException catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = e.message.isNotEmpty
          ? e.message
          : 'Request timed out. Please try again.';
      log('❌ Create user failed: ${e.message}');
      notifyListeners();
    } catch (e) {
      await _rollbackFirebaseUser(firebaseUser);
      error = 'Failed to create account. Please try again.';
      log('❌ Create user failed: $e');
      notifyListeners();
    }
  }

  /// Handle existing OAuth user sign-in.
  ///
  /// Mirrors [PhoneAuthhProvider._handleExistingPhoneUser].
  Future<void> _handleExistingUser(
    User firebaseUser, {
    required String fullname,
    String? email,
  }) async {
    // Try to create/verify backend user (idempotent – backend returns existing user)
    try {
      final map = <String, dynamic>{
        "firebaseUid": firebaseUser.uid,
        "fullname": fullname,
      };
      if (email != null && email.trim().isNotEmpty) {
        map["email"] = email;
      }

      final userId = await _authData.createUser(map);
      await _sharedPrefs.setUserId(userId);
      log('✅ Backend user verified for OAuth user');
    } on BadRequestException catch (e) {
      log('ℹ️ Backend user may already exist: ${e.message}');
    } on UnauthorisedException catch (e) {
      log('⚠️ Backend auth error during user creation: ${e.message}');
    } catch (e) {
      log('⚠️ Could not verify/create backend user: $e');
    }

    // Check if user has completed onboarding (has a profile)
    try {
      await _profileData.getUser();
      log('✅ Profile exists - navigating to home');
      _navigationService.goNamed(TabView.routeName);
    } on ProfileNotFoundException {
      log('📝 No profile found - redirecting to onboarding');
      _navigationService.goNamed(KidName.routeName);
    } catch (e) {
      log('⚠️ Error checking profile, redirecting to onboarding: $e');
      _navigationService.goNamed(KidName.routeName);
    }
  }

  /// Rollback Firebase user creation if backend operations fail.
  ///
  /// Mirrors [PhoneAuthhProvider._rollbackFirebaseUser].
  Future<void> _rollbackFirebaseUser(User? user) async {
    if (user != null) {
      try {
        await user.delete();
        log('✅ Firebase user rolled back successfully');
      } catch (e) {
        log('❌ Failed to rollback Firebase user: $e');
        try {
          await _firebaseAuth.signOut();
        } catch (signOutError) {
          log('❌ Failed to sign out after rollback: $signOutError');
        }
      }
    }
  }

  // ── Apple Sign-In helpers ───────────────────────────────────────────

  /// Generates a cryptographically-secure random nonce.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the SHA256 hash of [input] as a hex string.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Build a full name from Apple's given/family name fields.
  /// Returns null if both are null/empty.
  String? _buildAppleName({String? givenName, String? familyName}) {
    final parts = <String>[];
    if (givenName != null && givenName.trim().isNotEmpty) {
      parts.add(givenName.trim());
    }
    if (familyName != null && familyName.trim().isNotEmpty) {
      parts.add(familyName.trim());
    }
    return parts.isNotEmpty ? parts.join(' ') : null;
  }
}
