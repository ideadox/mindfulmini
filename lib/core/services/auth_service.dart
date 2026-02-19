import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

/// Centralised authentication service.
///
/// Single source of truth for auth state across the app.
/// Wraps [FirebaseAuth] so that no other file needs to depend on it
/// directly for auth-state concerns (the only exception is [HttpService],
/// which uses `getIdToken()` for per-request token management).
///
/// Usage:
///   1. Register as a singleton in DI.
///   2. Call [initialize] once at app startup (after Firebase.initializeApp).
///   3. Inject via `sl<AuthService>()` wherever auth state is needed.
class AuthService {
  final FirebaseAuth _firebaseAuth;

  StreamSubscription<User?>? _authStateSub;

  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  // ── Getters ──────────────────────────────────────────────────────────

  /// Whether a Firebase user is currently signed in.
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  /// The current Firebase user, or `null` if signed out.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Exposes the underlying auth-state stream so that widgets / providers
  /// can react to login / logout events if needed.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // ── Lifecycle ────────────────────────────────────────────────────────

  /// Call once at app startup after `Firebase.initializeApp()`.
  ///
  /// Performs a lightweight auth-state check and starts listening to
  /// auth-state changes for the lifetime of the app.
  Future<void> initialize() async {
    _logCurrentAuthState();
    _startAuthStateListener();
  }

  /// Log the current auth state at startup.
  ///
  /// Firebase Auth SDK persists the user session to disk automatically.
  /// We intentionally do NOT force-refresh tokens here or sign the user
  /// out on network failures — [HttpService] handles token freshness
  /// per-request via `getIdToken()`.
  void _logCurrentAuthState() {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        log('✅ Firebase user found at startup: ${user.uid}');
      } else {
        log('ℹ️ No Firebase user at startup – user needs to log in');
      }
    } catch (e) {
      log('❌ Error checking auth state at startup: $e');
    }
  }

  /// Listen to Firebase auth-state changes for the lifetime of the app.
  ///
  /// This fires when the user signs in or out, and also when the Firebase
  /// ID-token is refreshed internally.
  void _startAuthStateListener() {
    _authStateSub?.cancel();
    _authStateSub = _firebaseAuth.authStateChanges().listen(
      (user) {
        if (user == null) {
          log('🔓 authStateChanges → signed out');
        } else {
          log('✅ authStateChanges → signed in: ${user.uid}');
        }
      },
      onError: (error) {
        log('❌ authStateChanges error: $error');
      },
    );
  }

  // ── Auth Actions ─────────────────────────────────────────────────────

  /// Sign out the current user.
  ///
  /// After this call `isAuthenticated` will return `false` and the
  /// `authStateChanges` stream will emit `null`.
  Future<void> signOut() async {
    try {
      log('🔓 AuthService: signing out');
      await _firebaseAuth.signOut();
    } catch (e) {
      log('❌ AuthService: error during sign-out: $e');
      rethrow;
    }
  }

  // ── Cleanup ──────────────────────────────────────────────────────────

  /// Cancel the auth-state subscription. Call if the service is ever
  /// disposed (unlikely for a singleton, but good hygiene).
  void dispose() {
    _authStateSub?.cancel();
    _authStateSub = null;
  }
}
