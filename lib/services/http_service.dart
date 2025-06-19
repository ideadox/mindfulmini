import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'exceptions.dart';
import 'dart:async';

class HttpService {
  final Duration _timeOutDuration = Duration(hours: 1);
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(_timeOutDuration);

      return _returnResponse(response);
    } on ClientException {
      throw "Can't access the server";
    }
  }

  Future<dynamic> patch(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    return _returnResponse(response);
  }

  Future<dynamic> post(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      return _returnResponse(response);
    } on ClientException {
      throw "Can't access the server";
    }
  }

  Future<dynamic> put(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await http
          .put(Uri.parse(url), headers: headers, body: body)
          .timeout(_timeOutDuration);

      return _returnResponse(response);
    } on ClientException {
      throw "Can't access the server";
    }
  }

  Future<dynamic> delete(
    String url, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await http
          .delete(Uri.parse(url), headers: headers, body: body)
          .timeout(_timeOutDuration);

      return _returnResponse(response);
    } on ClientException {
      throw "Can't access the server";
    }
  }

  dynamic _returnResponse(http.Response response) {
    // log(response.body.toString());
    switch (response.statusCode) {
      case 200:
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
      case 400 || 409:
        throw BadRequestException(
          jsonDecode(response.body)['error'] == null
              ? jsonDecode(response.body).containsKey('message')
                  ? jsonDecode(response.body)['message'].toString()
                  : response.body.toString()
              : jsonDecode(response.body)['error'].toString(),
        );
      case 403:
        throw UnauthorisedException(
          jsonDecode(response.body)['error'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['error'].toString(),
        );

      case 404:
        throw UnauthorisedException(
          jsonDecode(response.body)['error'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['error'].toString(),
        );
      case 401:
        throw UnauthorisedException(
          jsonDecode(response.body)['error'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['error'].toString(),
        );

      case 408:
        throw TimeoutException(
          jsonDecode(response.body)['error'] == null
              ? response.body.toString()
              : jsonDecode(response.body)['error'].toString(),
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
      // case 500:
      default:
        throw FetchDataException(
          'Error occured while communication with server'
          ' with status code : ${response.statusCode}',
        );
    }
  }
}
