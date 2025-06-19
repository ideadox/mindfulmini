import 'dart:developer';

import '../../../core/api_constants.dart';
import '../../../services/http_service.dart';

class ProfileData {
  final HttpService httpService;
  ProfileData({required this.httpService});
  Future<void> getUser(String userId) async {
    try {
      final res = await httpService.get(ApiConstants.getUser + userId);
      log(res.toString());
    } catch (e) {
      rethrow;
    }
  }
}
