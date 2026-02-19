import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:mindfulminis/core/services/exceptions.dart';
import 'dart:async';

/// HttpService with automatic Firebase token management and 401 retry.
///
/// How auth works:
/// - Every request gets a fresh Firebase ID token via `getIdToken()`.
///   Firebase SDK caches valid tokens internally (no network call unless
///   the cached token is about to expire or already expired).
/// - If the backend returns 401 (expired / revoked token), we force-refresh
///   the token with `getIdToken(true)` and retry the request **once** (new
///   http.Request object, so no finalization issues).
/// - If the retry also 401s, the user is signed out (account may have been
///   deleted / disabled server-side).
class HttpService {
  static const int _maxAuthRetries = 2; // 1 original + 1 retry after refresh

  final http.Client _client = http.Client();
  final Duration _timeOutDuration = const Duration(seconds: 15);

  // ── helpers ──────────────────────────────────────────────────────────

  /// Get a valid Firebase ID token. Returns null if no user is signed in.
  /// [forceRefresh] = true forces a network call to Firebase to mint a
  /// brand-new token (used after a 401).
  Future<String?> _getFirebaseToken({bool forceRefresh = false}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      // Firebase SDK caches the token and only refreshes when needed,
      // so calling getIdToken() without forceRefresh is cheap.
      return await user.getIdToken(forceRefresh);
    } catch (e) {
      log('❌ Error getting Firebase token: $e');
      return null;
    }
  }

  /// Build headers with the current Firebase ID token.
  Future<Map<String, String>> _buildHeaders(
    Map<String, String>? extraHeaders,
  ) async {
    final token = await _getFirebaseToken();
    final headers = <String, String>{};
    if (extraHeaders != null) headers.addAll(extraHeaders);
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Build headers with a force-refreshed Firebase ID token (for retry).
  Future<Map<String, String>> _buildRefreshedHeaders(
    Map<String, String>? extraHeaders,
  ) async {
    final token = await _getFirebaseToken(forceRefresh: true);
    if (token == null) {
      log('❌ Force-refresh returned null – no Firebase user');
      throw UnauthorisedException('Authentication failed. Please log in again.');
    }
    final headers = <String, String>{};
    if (extraHeaders != null) headers.addAll(extraHeaders);
    headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  /// Sign out & clear state when auth is unrecoverable.
  Future<void> _handlePersistentAuthFailure() async {
    try {
      log('🔓 Signing out – persistent auth failure');
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      log('❌ Error during sign-out: $e');
    }
  }

  // ── public HTTP methods ─────────────────────────────────────────────

  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    return _requestWithAuthRetry(
      method: 'GET',
      url: url,
      headers: headers,
    );
  }

  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return _requestWithAuthRetry(
      method: 'POST',
      url: url,
      headers: headers,
      body: body,
    );
  }

  Future<dynamic> patch(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return _requestWithAuthRetry(
      method: 'PATCH',
      url: url,
      headers: headers,
      body: body,
    );
  }

  Future<dynamic> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return _requestWithAuthRetry(
      method: 'PUT',
      url: url,
      headers: headers,
      body: body,
    );
  }

  Future<dynamic> delete(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    return _requestWithAuthRetry(
      method: 'DELETE',
      url: url,
      headers: headers,
      body: body,
    );
  }

  // ── core request + auth-retry loop ──────────────────────────────────

  /// Executes an HTTP request with automatic 401 retry.
  ///
  /// Attempt 1: uses cached Firebase ID token.
  /// If 401 → force-refreshes the token and tries once more (Attempt 2).
  /// If 401 again → signs the user out.
  Future<dynamic> _requestWithAuthRetry({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) async {
    for (int attempt = 1; attempt <= _maxAuthRetries; attempt++) {
      try {
        // On first attempt, use cached token. On retry, force-refresh.
        final resolvedHeaders = attempt == 1
            ? await _buildHeaders(headers)
            : await _buildRefreshedHeaders(headers);

        final response = await _sendRequest(
          method: method,
          url: url,
          headers: resolvedHeaders,
          body: body,
        );

        return _processResponse(response);
      } on _TokenExpiredException {
        if (attempt < _maxAuthRetries) {
          log('🔄 401 received – retrying with force-refreshed token (attempt ${attempt + 1}/$_maxAuthRetries)');
          continue; // retry with force-refreshed token
        }
        // Exhausted retries – sign out
        log('❌ Persistent 401 after $_maxAuthRetries attempts – signing out');
        await _handlePersistentAuthFailure();
        throw UnauthorisedException(
          'Authentication failed. Please log in again.',
        );
      }
    }
    // Should not reach here, but just in case:
    throw FetchDataException('Request failed unexpectedly');
  }

  /// Sends a single HTTP request (no auth retry logic here).
  Future<http.Response> _sendRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    dynamic body,
  }) async {
    final uri = Uri.parse(url);
    try {
      switch (method) {
        case 'GET':
          return await _client.get(uri, headers: headers).timeout(_timeOutDuration);
        case 'POST':
          return await _client.post(uri, headers: headers, body: body).timeout(_timeOutDuration);
        case 'PATCH':
          return await _client.patch(uri, headers: headers, body: body).timeout(_timeOutDuration);
        case 'PUT':
          return await _client.put(uri, headers: headers, body: body).timeout(_timeOutDuration);
        case 'DELETE':
          return await _client.delete(uri, headers: headers, body: body).timeout(_timeOutDuration);
        default:
          throw FetchDataException('Unsupported HTTP method: $method');
      }
    } on SocketException {
      throw FetchDataException('No internet connection');
    } on HttpException {
      throw FetchDataException('HTTP error occurred');
    } on http.ClientException {
      throw FetchDataException('Network error occurred');
    }
  }

  // ── response processing ─────────────────────────────────────────────

  /// Process the HTTP response. Throws [_TokenExpiredException] on 401
  /// so the retry loop can handle it. Other errors throw the appropriate
  /// app-level exception.
  dynamic _processResponse(http.Response response) {
    // Special case: custom 498 status
    if (response.statusCode == 498) {
      final responseJson = jsonDecode(response.body);
      SmartDialog.showToast(responseJson['message']);
      throw UnauthorisedException(responseJson['message']);
    }

    switch (response.statusCode) {
      case 200:
        final responseJson = jsonDecode(response.body);
        if (responseJson is Map<String, dynamic> &&
            responseJson.containsKey('status') &&
            responseJson['status'] != null) {
          if (responseJson['status'] == false) {
            throw InvalidInputException(
              responseJson.containsKey('message')
                  ? responseJson['message'].toString()
                  : 'Unknown error occurred.',
            );
          }
        }
        return responseJson;

      case 201:
        final responseJson = jsonDecode(response.body);
        if (responseJson is Map<String, dynamic> &&
            responseJson.containsKey('type') &&
            responseJson['type'] != null) {
          if (responseJson['type'] == 'error') {
            throw UnauthorisedException(
              responseJson.containsKey('message')
                  ? responseJson['message'].toString()
                  : 'Unknown error occurred.',
            );
          }
        }
        return responseJson;

      case 400:
      case 409:
      case 429:
        final decoded = jsonDecode(response.body);
        throw BadRequestException(
          decoded['error'] != null
              ? decoded['error'].toString()
              : decoded.containsKey('message')
                  ? decoded['message'].toString()
                  : response.body.toString(),
        );

      case 401:
        // Signal the retry loop to force-refresh and retry
        throw _TokenExpiredException();

      case 403:
        throw UnauthorisedException(
          _extractMessage(response),
        );

      case 404:
        throw UnauthorisedException(
          _extractMessage(response),
        );

      case 408:
        throw TimeoutException(
          _extractMessage(response),
        );

      case 302:
      case 303:
      case 304:
      case 418:
        throw UnauthorisedException(
          _extractMessage(response),
        );

      case 422:
        throw InvalidInputException(
          _extractMessage(response),
        );

      default:
        throw FetchDataException(
          'Error occurred while communicating with server (${response.statusCode})',
        );
    }
  }

  /// Safely extract 'message' from a JSON response body.
  String _extractMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      return decoded['message']?.toString() ?? response.body.toString();
    } catch (_) {
      return response.body.toString();
    }
  }
}

/// Internal exception used only to signal a 401 to the retry loop.
/// Never escapes [HttpService].
class _TokenExpiredException implements Exception {}
