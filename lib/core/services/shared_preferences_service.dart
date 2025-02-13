import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  Future<void> setToken(String token) async {
    await _sharedPreferences.setString('token', token);
  }

  String? getToken() => _sharedPreferences.getString('token');

  Future<void> clearToken() async {
    await _sharedPreferences.clear();
  }
}
