import 'dart:developer';
import 'package:blutut_clasic/injection.dart';
import 'package:dio/dio.dart';
import '../../core/services/shared_preferences_service.dart';

class RemoteAuthProvider{
  final Dio _dio;

  const RemoteAuthProvider({required Dio dio}) : _dio = dio;


  Future<void> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'https://app.ptmakassartrans.com/index.php/auth/login.json',
        data: {
          'username': 'administrator',
          'password': 'sikomolewat12kali',
        },
        options: Options(headers: {
          "Accept": "application/json, text/javascript, */*; q=0.01",
          "Content-Type": "application/x-www-form-urlencoded",
          "Origin": "https://app.ptmakassartrans.com",
          "Referer": "https://app.ptmakassartrans.com/index.php/auth/",
          "X-Requested-With": "XMLHttpRequest",
        }),
      );

      print(response.statusCode);
      print(response.data);
      print(response.headers['set-cookie']);

      var token;
      for (var cookie in response.headers['set-cookie'] ?? []) {
        var cookieParts = cookie.split(';');
        var cookieName = cookieParts[0].split('=')[0].trim();
        var cookieValue = cookieParts[0].split('=')[1].trim();
        if (cookieName == 'siklonsession') {
          token = cookieValue;
          serviceLocator<SharedPreferencesService>().setToken(token);
        }
      }

      log("siklonsession=$token");

      if (token != null) {
        final response_user_info = await fetchUserInfo(token);
        print(response_user_info);
      }

      if (response.statusCode == 200) {
        print("Login Success");
      } else {
        print("Login Failed");
      }
    } catch (e) {
      print("Login Error: \$e");
    }
  }

  Future<Map<String, dynamic>?> fetchUserInfo(String token) async {
    try {
      final response = await _dio.post(
        'https://app.ptmakassartrans.com/index.php/usermanagement/info.json',
        options: Options(headers: {
          'cookie': "siklonsession=$token",
        }),
      );

      return response.data as Map<String, dynamic>?;
    } catch (e) {
      print("Fetch User Info Error: \$e");
      return null;
    }
  }
}
