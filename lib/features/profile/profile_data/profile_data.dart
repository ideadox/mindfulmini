import 'dart:convert';

import 'package:mindfulminis/features/profile/models/user_profile.dart';

import '../../../core/api_constants.dart';
import '../../../services/http_service.dart';

class ProfileData {
  final HttpService httpService;
  ProfileData({required this.httpService});
  Future<UserProfile> getUser() async {
    try {
      final res = await httpService.get(ApiConstants.listProfilesUrl);

      return UserProfile.fromJson(res['data'][0]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    try {
      await httpService.patch(
        '${ApiConstants.updateProfileUrl}/${updatedProfile.id}',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedProfile.toName()),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editImage(String profileId, String imageUrl) async {
    try {
      await httpService.patch(
        '${ApiConstants.updateProfileUrl}/$profileId',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': imageUrl}),
      );
    } catch (e) {
      rethrow;
    }
  }
}
