
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceKey {
  static const KEY_ACCESS_TOKEN = "KEY_ACCESS_TOKEN";
  static const KEY_REFRESH_TOKEN = "KEY_REFRESH_TOKEN";
  static const KEY_ID_TOKEN = "KEY_ID_TOKEN";
  static const KEY_LANGUAGE_CODE = "KEY_LANGUAGE_CODE";

  static clearAll() async{
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}