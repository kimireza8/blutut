import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  Future<void> setCookie(String cookie) async {
    await setString('cookie', cookie);
  }

  String? getCookie() => getString('cookie');

  Future<void> clearCookie() async {
    await _sharedPreferences.clear();
  }

  Future<void> setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  String? getString(String key) => _sharedPreferences.getString(key);
}
