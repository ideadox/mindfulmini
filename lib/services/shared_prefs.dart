import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  final SharedPreferences prefs;

  SharedPrefs({required this.prefs});

  final String userIdKey = 'userId';

  Future<bool> setUserId(String userId) async {
    return await prefs.setString(userIdKey, userId);
  }

  String? getUserId() {
    return prefs.getString(userIdKey);
  }
}
