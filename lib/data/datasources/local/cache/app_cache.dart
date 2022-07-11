import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> _init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }

  static String getString(String key) {
    if (_prefs == null) _init();
    return _prefs?.getString(key) ?? "";
  }

  static void setString({String key = "", String value = ""}) {
    if (_prefs == null) _init();
    else{
      if (value.isEmpty || key.isEmpty) return;
      _prefs?.setString(key, value);
    }
  }
  static void removeString({String key = "", String value = ""}) {
    if (_prefs == null) _init();
    else{
      if (value.isEmpty || key.isEmpty) return;
      _prefs?.remove(key);
    }
  }
}