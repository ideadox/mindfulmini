import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:mindfulminis/services/storage/token_storage.dart';
import 'firebase_options.dart';
import 'package:mindfulminis/mindfulminis.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Initialize the Branch SDK first
  await FlutterBranchSdk.init();
  // FlutterBranchSdk.validateSDKIntegration();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Setup dependency injection first
  await setupInjection();
  await sl.allReady();
  
  // Validate and fix auth state consistency
  await _validateAuthState();
  
  runApp(const Mindfulminis());
}

/// Validates auth state consistency between Firebase and local storage
/// Handles cases where app was uninstalled/reinstalled and state is mismatched
Future<void> _validateAuthState() async {
  try {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final tokenStorage = sl<TokenStorage>();
    final token = await tokenStorage.getAccessToken();

    // Case 1: Firebase user exists but no token in storage
    // This can happen if app was uninstalled and Keychain was cleared but Firebase persisted
    // Or if secure storage failed to save
    if (firebaseUser != null && (token == null || token.isEmpty)) {
      log('⚠️ Auth state mismatch: Firebase user exists but no token found. Signing out...');
      try {
        // Try to get a fresh token from Firebase
        final freshToken = await firebaseUser.getIdToken(true);
        if (freshToken != null && freshToken.isNotEmpty) {
          // Save the fresh token
          await tokenStorage.saveAccessToken(freshToken);
          log('✅ Successfully refreshed and saved token');
        } else {
          // If we can't get a token, sign out to maintain consistency
          await FirebaseAuth.instance.signOut();
          log('⚠️ Could not get fresh token, signed out for consistency');
        }
      } catch (e) {
        // If token refresh fails, sign out to maintain consistency
        log('❌ Failed to refresh token: $e. Signing out for consistency...');
        await FirebaseAuth.instance.signOut();
      }
    }
    // Case 2: Token exists but no Firebase user
    // This shouldn't normally happen, but if it does, clear the token
    else if (firebaseUser == null && token != null && token.isNotEmpty) {
      log('⚠️ Auth state mismatch: Token exists but no Firebase user. Clearing token...');
      await tokenStorage.clear();
    }
    // Case 3: Both exist - validate token is still valid
    else if (firebaseUser != null && token != null && token.isNotEmpty) {
      try {
        // Verify token is still valid by attempting to refresh it
        await firebaseUser.getIdToken(true);
        log('✅ Auth state is consistent and valid');
      } catch (e) {
        log('⚠️ Token validation failed: $e. Clearing auth state...');
        await FirebaseAuth.instance.signOut();
        await tokenStorage.clear();
      }
    }
  } catch (e) {
    log('❌ Error validating auth state: $e');
    // Don't throw - let app continue, but log the error
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
