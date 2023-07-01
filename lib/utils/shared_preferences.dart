import 'package:esgi_tweet/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {

  static late SharedPreferences preferences;
  static const _darkModeKey = 'darkMode';

  static Future initPref() async => preferences = await SharedPreferences.getInstance();

  static Future setUserId(String id) async => {
    await preferences.setString('id', id),
  };

  static String? getUserId() => preferences.getString('id') ?? "pas d'id";

  static removePreferences() async => await preferences.clear();

  static bool isDarkModeEnabled() {
    return UserSharedPreferences.preferences.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    await UserSharedPreferences.preferences.setBool(_darkModeKey, value);
  }
}