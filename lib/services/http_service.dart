import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:mindfulminis/services/exceptions.dart';
import 'package:mindfulminis/services/storage/token_storage.dart';
import 'package:retry/retry.dart';
import 'dart:async';

import '../injection/injection.dart';

/// A wrapper around http.Client that adds retry + token refresh support
class RetryAndRefreshClient extends http.BaseClient {
  final http.Client _inner;
  final Future<String?> Function() _getAccessToken;

  final int maxRetries;
  String? _accessToken;
  // static bool _sessionExpiredShown = false;

  RetryAndRefreshClient({
    http.Client? inner,
    required Future<String?> Function() getAccessToken,
    this.maxRetries = 3,
  }) : _inner = inner ?? http.Client(),
       _getAccessToken = getAccessToken;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _accessToken = await _getAccessToken();

    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }
    log(_accessToken.toString());

    int attempt = 0;
    while (true) {
      attempt++;

      final response = await _inner.send(request);

      // Retry on 5xx server errors or network issues
      if (_shouldRetry(response.statusCode) && attempt < maxRetries) {
        await Future.delayed(Duration(seconds: 2 * attempt)); // backoff
        continue;
      }

      return response;
    }
  }

  bool _shouldRetry(int? statusCode) {
    if (statusCode == null) return true;
    return statusCode >= 500;
  }
}

class HttpService {
  final client = RetryAndRefreshClient(
    getAccessToken: () async {
      final token = await sl<TokenStorage>().getAccessToken();
      return token;
    },
  );

  final r = RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(milliseconds: 500), // exponential backoff base
  );

  Future<T> retryRequest<T>(Future<T> Function() requestFn) {
    return r.retry(
      requestFn,
      retryIf:
          (e) =>
              e is SocketException ||
              e is TimeoutException ||
              e is HttpException ||
              e is http.ClientException,
    );
  }

  final Duration _timeOutDuration = Duration(seconds: 15);
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    final response = await retryRequest(
      () => client
          .get(Uri.parse(url), headers: headers)
          .timeout(_timeOutDuration),
    );

    return _returnResponse(response);
  }

  Future<dynamic> patch(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await retryRequest(
      () => client
          .patch(Uri.parse(url), headers: headers, body: body)
          .timeout(_timeOutDuration),
    );
    return _returnResponse(response);
  }

  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await retryRequest(
      () => client
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(_timeOutDuration),
    );

    return _returnResponse(response);
  }

  Future<dynamic> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await retryRequest(
      () => client
          .put(Uri.parse(url), headers: headers, body: body)
          .timeout(_timeOutDuration),
    );

    return _returnResponse(response);
  }

  Future<dynamic> delete(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await retryRequest(
      () => client
          .delete(Uri.parse(url), headers: headers, body: body)
          .timeout(_timeOutDuration),
    );

    return _returnResponse(response);
  }

  dynamic _returnResponse(http.Response response) {
    log(response.statusCode.toString());
    log(response.body.toString());

    if (response.statusCode == 498) {
      final responseJson = jsonDecode(response.body);
      SmartDialog.showToast(responseJson['message']);
      // sl<AuthNotifier>().logout();
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
      case 400 || 409 || 429:
        throw BadRequestException(
          jsonDecode(response.body)['error'] == null
              ? jsonDecode(response.body).containsKey('message')
                  ? jsonDecode(response.body)['message'].toString()
                  : response.body.toString()
              : jsonDecode(response.body)['error'].toString(),
        );
      case 403:
        throw UnauthorisedException(
          jsonDecode(response.body)['message'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['message'].toString(),
        );

      case 404:
        throw UnauthorisedException(
          jsonDecode(response.body)['message'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['message'].toString(),
        );
      case 401:
        throw UnauthorisedException(
          jsonDecode(response.body)['message'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['message'].toString(),
        );

      case 408:
        throw TimeoutException(
          jsonDecode(response.body)['message'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['message'].toString(),
        );
      case 302:
        throw UnauthorisedException(
          jsonDecode(response.body)['message'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['message'].toString(),
        );
      case 303:
        throw UnauthorisedException(
          jsonDecode(response.body)['message'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['message'].toString(),
        );
      case 304:
        throw UnauthorisedException(
          jsonDecode(response.body)['message'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['message'].toString(),
        );
      case 418:
        throw UnauthorisedException(
          jsonDecode(response.body)['message'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['message'].toString(),
        );

      case 422:
        throw InvalidInputException(
          jsonDecode(response.body)['message'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['message'].toString(),
        );
      // case 500:
      default:
        throw FetchDataException(
          'Error occured while communication with server',
        );
    }
  }
}
