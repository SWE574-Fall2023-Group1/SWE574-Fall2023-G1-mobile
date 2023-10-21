import 'package:shared_preferences/shared_preferences.dart';

class SPKeys {
  static const String refreshTokenKey = "refreshToken";
}

class SPHelper {
  static Future<void> setString(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  static Future<void> remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }
}
