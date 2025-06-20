import 'dart:convert';
import 'dart:developer';

import 'package:mindfulminis/features/profile/models/user_profile.dart';

import '../../../core/api_constants.dart';
import '../../../services/http_service.dart';

class ProfileData {
  final HttpService httpService;
  ProfileData({required this.httpService});
  Future<UserProfile> getUser(String userId) async {
    try {
      final res = await httpService.get(ApiConstants.getUserUrl + userId);
      log(res.toString());
      return UserProfile.fromJson(res['data']['profiles'][0]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile, String userId) async {
    try {
      final res = await httpService.post(
        ApiConstants.updateUserUrl + userId,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedProfile.toJson()),
      );
      log(res.toString());
      // return UserProfile.fromJson(res['data']['profiles'][0]);
    } catch (e) {
      rethrow;
    }
  }
}
