import 'package:esgi_tweet/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {

  static late SharedPreferences preferences;

  static Future initPref() async => preferences = await SharedPreferences.getInstance();

  static Future setUserId(String id) async => {
    await preferences.setString('id', id),
  };

  static String? getUserId() => preferences.getString('id') ?? "pas d'id";

  static removePreferences() async => await preferences.clear();

}