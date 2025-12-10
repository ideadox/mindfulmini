class ApiConstants {
  static String baseUrl = 'https://apiv1.mindfulminis.in/api/v1';
  static String mediaBaseUrl =
      'https://minfulminis.s3.eu-north-1.amazonaws.com/payloadcms';

  //user
  static String createUserUrl = '$baseUrl/users';
  static String createProfileUrl = '$baseUrl/profiles';
  static String loginUserUrl = '$baseUrl/users/login';
  static String listProfilesUrl = '$baseUrl/profiles';
  static String updateProfileUrl = '$baseUrl/profiles';

  //old below
  static String addUserUrl = '$baseUrl/api/profile/addProfile';
  static String updateUserUrl = '$baseUrl/api/profile/updateProfile';
  static String getUserUrl = '$baseUrl/api/profile/getProfilesByUserId/';
  // static String updateProfileUrl = '$baseUrl/profiles';

  //routine
  static String createRoutineUrl = '$baseUrl/routines';
  static String getRoutinesUrl = '$baseUrl/routines';
  static String getRoutineActivityUrl = '$baseUrl/api/activity/getActivity';
  static String updateRoutineActivityPercentUrl =
      '$baseUrl/api/activityContent/updateActivityContentProgressById/';

  //gratitude journal
  static String addGratitudeJournalUrl = '$baseUrl/activities/gratitude';
  static String getGratitudeJournalUrl = '$baseUrl/activities/gratitude';
  static String uploadMediaUrl = '$baseUrl/upload';

  // cms

  static String cmsUrl = '$baseUrl/cms';

  static String cmsByIdUrl = '$baseUrl/cms/content';
  static String getGoalsUrl = '$baseUrl/routines/goals';
  static String getMonthlyGratitudeUrl = '$baseUrl//activities/gratitude/month';
  // /routines/goals?routineId=6912fd515fcf7118e9c04553&date=2025-11-11
  // /activities/gratitude/month?profileId=690dcfdc78f23500d69992bd&year=2025&month=11
}
