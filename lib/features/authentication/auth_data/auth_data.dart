import 'dart:convert';
import 'dart:developer';

import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/core/services/http_service.dart';

class AuthData {
  final HttpService httpService;
  AuthData({required this.httpService});
  Future<String> createUser(var map) async {
    try {
      final res = await httpService.post(
        ApiConstants.createUserUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(map),
      );
      log(res.toString());
      return res['data']['id'];
    } catch (e) {
      rethrow;
    }
  }

}
