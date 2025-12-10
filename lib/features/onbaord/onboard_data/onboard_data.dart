import 'dart:convert';
import 'dart:developer';

import '../../../core/api_constants.dart';
import '../../../services/http_service.dart';

class OnboardData {
  final HttpService httpService;
  OnboardData({required this.httpService});
  Future<void> addUser(var map) async {
    try {
      final res = await httpService.post(
        ApiConstants.createProfileUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(map),
      );
      log(res.toString());
    } catch (e) {
      rethrow;
    }
  }
}
