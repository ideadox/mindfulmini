import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindfulminis/features/authentication/auth_data/auth_data.dart';
import 'package:mindfulminis/features/onbaord/screens/kid_name.dart';
import 'package:mindfulminis/injection/injection.dart';
import 'package:mindfulminis/services/exceptions.dart';

import '../../../services/shared_prefs.dart';
import '../../../services/storage/token_storage.dart';

class CreateAccountProvoider with ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthData _authData = sl<AuthData>();
  final SharedPrefs _sharedPrefs = sl<SharedPrefs>();
  final _tokenStorage = sl<TokenStorage>();

  bool isVisible = false;

  void toogleVisiblity() {
    isVisible = !isVisible;
    notifyListeners();
  }

  bool loading = false;

  String? error;

  void resetError() {
    error = null;
  }

  Future<void> signUp() async {
    resetError();
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    User? firebaseUser;
    bool firebaseUserCreated = false;
    
    try {
      loading = true;
      notifyListeners();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      String name = nameController.text.trim();
      
      // Step 1: Create Firebase user
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      
      if (credential.user != null) {
        firebaseUser = credential.user;
        firebaseUserCreated = true;
        
        // Step 2: Update display name
        await firebaseUser!.updateDisplayName(name);

        // Step 3: Create user in backend API
        try {
          var map = {
            "email": email,
            "fullname": name,
            "firebaseUid": firebaseUser.uid,
            "password": password,
          };

          final userId = await _authData.createUser(map);
          
          // Step 4: Get Firebase token (use Firebase token directly, same as login flow)
          // The backend accepts Firebase tokens, not email/password for authentication
          try {
            // Get fresh Firebase token for the newly created user
            final token = await firebaseUser.getIdToken(true);
            
            if (token == null || token.isEmpty) {
              throw Exception('Failed to get authentication token from Firebase');
            }
            
            // Step 5: Save user data and navigate
            await _sharedPrefs.setUserId(userId);
            await _tokenStorage.saveAccessToken(token);
            log('✅ Signup successful - User created and token saved');
            sl<GoRouter>().goNamed(KidName.routeName);
          } catch (e) {
            // Rollback: Delete Firebase user if token retrieval fails
            await _rollbackFirebaseUser(firebaseUser);
            error = 'Failed to complete signup. Please try again.';
            log('❌ Token retrieval failed during signup: $e');
          }
        } on InvalidInputException catch (e) {
          // Rollback: Delete Firebase user if create user fails
          await _rollbackFirebaseUser(firebaseUser);
          error = e.message.isNotEmpty ? e.message : 'Invalid information. Please check your details.';
          log('Create user failed: ${e.message}');
        } on BadRequestException catch (e) {
          await _rollbackFirebaseUser(firebaseUser);
          error = e.message.isNotEmpty ? e.message : 'Invalid request. Please check your information.';
          log('Create user failed: ${e.message}');
        } on UnauthorisedException catch (e) {
          await _rollbackFirebaseUser(firebaseUser);
          error = e.message.isNotEmpty ? e.message : 'Authentication failed. Please try again.';
          log('Create user failed: ${e.message}');
        } on FetchDataException catch (e) {
          await _rollbackFirebaseUser(firebaseUser);
          error = e.message.isNotEmpty ? e.message : 'Server error. Please try again later.';
          log('Create user failed: ${e.message}');
        } on TimeoutException catch (e) {
          await _rollbackFirebaseUser(firebaseUser);
          error = e.message.isNotEmpty ? e.message : 'Request timed out. Please check your connection and try again.';
          log('Create user failed: ${e.message}');
        } catch (e) {
          await _rollbackFirebaseUser(firebaseUser);
          error = 'Failed to create account. Please try again.';
          log('Create user failed: $e');
        }
      } else {
        error = 'Failed to create account. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      log('Firebase auth error: ${e.toString()}');
      error = ResolveError.resolve(e.code);
    } catch (e) {
      // If Firebase user was created but we're here, something unexpected happened
      if (firebaseUserCreated && firebaseUser != null) {
        await _rollbackFirebaseUser(firebaseUser);
      }
      error = 'An unexpected error occurred. Please try again.';
      log('Unexpected error during signup: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Rollback Firebase user creation if backend operations fail
  Future<void> _rollbackFirebaseUser(User? user) async {
    if (user != null) {
      try {
        await user.delete();
        log('Firebase user rolled back successfully');
      } catch (e) {
        log('Failed to rollback Firebase user: $e');
        // If deletion fails, try to sign out at least
        try {
          await FirebaseAuth.instance.signOut();
        } catch (signOutError) {
          log('Failed to sign out after rollback: $signOutError');
        }
      }
    }
  }
}
