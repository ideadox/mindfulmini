class ApiConstants {
  static String baseUrl = 'https://apiv1.mindfulminis.in';

  //user
  static String createUserUrl = '$baseUrl/api/user/getUser';
  static String addUserUrl = '$baseUrl/api/profile/addProfile';
  static String updateUserUrl = '$baseUrl/api/profile/updateProfile/';
  static String getUserUrl = '$baseUrl/api/profile/getProfilesByUserId/';

  //routine
  static String createRoutineUrl = '$baseUrl/api/routine/addRoutine';
  static String getRoutinesUrl = '$baseUrl/api/routine/getRoutinesByProfileId/';
}
