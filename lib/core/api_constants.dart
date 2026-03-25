class ApiConstants {
  // Production URL
  static String baseUrl = 'https://devapi.mindfulminis.life/api/v1';
  //static String baseUrl = 'http://localhost:3000/api/v1';
  
  // Old bucket (deprecated)
  // static String mediaBaseUrl =
  // 'https://minfulminis.s3.eu-north-1.amazonaws.com/payloadcms/';

  // New bucket in ap-south-1 (Mumbai) - with payloadcms folder
  static String mediaBaseUrl =
      'https://mm-lite-store.s3.ap-south-1.amazonaws.com/payloadcms/';
  //user
  static String createUserUrl = '$baseUrl/users';
  static String createProfileUrl = '$baseUrl/profiles';
  // Note: No /users/login route exists on the backend.
  // Auth is handled via Firebase ID tokens verified by the auth middleware.
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
  static String getGoalsUrl = '$baseUrl/routines/goals';
  static String getActivitiesUrl = '$baseUrl/activities/activity';
  static String updateActivityProgressUrl = '$baseUrl/activities/progress';
  static String getActivityContentUrl = '$baseUrl/activities/content';
  static String setActivityReactionUrl = '$baseUrl/activities/reaction';

  //gratitude journal
  static String addGratitudeJournalUrl = '$baseUrl/activities/gratitude';
  static String getGratitudeJournalUrl = '$baseUrl/activities/gratitude';
  static String uploadMediaUrl = '$baseUrl/upload';

  // cms

  static String cmsUrl = '$baseUrl/cms';

  static String cmsByIdUrl = '$baseUrl/cms/content';
  static String getMonthlyGratitudeUrl = '$baseUrl/activities/gratitude/month';

  // yoga
  static String getYogaUrl = '$baseUrl/cms/yoga';

  // meditation
  static String getMeditationUrl = '$baseUrl/cms/meditation';
  
  // breathing
  static String getBreathingUrl = '$baseUrl/cms/breathing';
  // /routines/goals?routineId=6912fd515fcf7118e9c04553&date=2025-11-11
  // /activities/gratitude/month?profileId=690dcfdc78f23500d69992bd&year=2025&month=11
  static String getStoriesUrl = '$baseUrl/cms/stories';
}
