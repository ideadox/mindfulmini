import 'dart:convert';
import 'dart:developer';

import 'package:mindfulminis/core/api_constants.dart';
import 'package:mindfulminis/services/http_service.dart';

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

  Future<String> loginUser(var map) async {
    try {
      final res = await httpService.post(
        ApiConstants.loginUserUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(map),
      );

      return res['data']['token'];
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> createUser(var map) async {
  //   try {
  //     final res = httpService.post(
  //       ApiConstants.createUser,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(map),
  //     );
  //     log(res.toString());
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
