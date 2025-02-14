import 'package:dio/dio.dart';

import '../../core/constants/constant.dart';
import '../../core/services/shared_preferences_service.dart';
import '../../core/utils/exceptions/auth_exceptions.dart';
import '../models/login_request_model.dart';

class RemoteAuthProvider {
  final Dio _dio;
  final SharedPreferencesService _sharedPreferencesService;

  static final _loginHeaders = {
    "Accept": "application/json, text/javascript, */*; q=0.01",
    "Content-Type": "application/x-www-form-urlencoded",
    "Origin": Constant.baseUrl,
    "Referer": '${Constant.baseUrl}/index.php/auth/',
    "X-Requested-With": "XMLHttpRequest",
  };

  const RemoteAuthProvider({
    required Dio dio,
    required SharedPreferencesService sharedPreferencesService,
  })  : _dio = dio,
        _sharedPreferencesService = sharedPreferencesService;

  Future<String> login(LoginRequest loginRequest) async {
    try {
      final response = await _dio.post(
        Constant.baseUrl + Constant.loginEndpoint,
        data: {
          'username': loginRequest.username,
          'password': loginRequest.password,
          'remember': loginRequest.rememberMe,
        },
        options: Options(headers: _loginHeaders),
      );

      final token = _extractSessionToken(response.headers['set-cookie'] ?? []);

      await _sharedPreferencesService.setCookie(token);

      final statusCode = response.statusCode;
      if (statusCode == 401) {
        throw InvalidCredentialsException('Invalid username or password.');
      } else if (statusCode != 200) {
        throw ServerException(
            'Login failed with status code: $statusCode');
      }

      return token;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AuthException('Unexpected error during login: $e');
    }
  }

  Future<void> logout() async {
    try {
      final cookie = _sharedPreferencesService.getCookie();
      final response = await _dio.get(
        '${Constant.baseUrl}/auth/logout/',
        options: Options(headers: {'Cookie': "siklonsession=$cookie"}),
      );

      final statusCode = response.statusCode;
      if (statusCode != 200) {
        throw ServerException('Logout failed with status code: $statusCode');
      }
      await _sharedPreferencesService.clearCookie();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AuthException('Unexpected error during logout: $e');
    }
  }

  String _extractSessionToken(List<String> cookies) {
    String? lastCookie;
    for (var cookie in cookies) {
        var cookieParts = cookie.split(';');
        var cookieName = cookieParts[0].split('=')[0].trim();
        var cookieValue = cookieParts[0].split('=')[1].trim();
        if (cookieName == 'siklonsession') {
          lastCookie = cookieValue;
        }
      }

    return lastCookie ?? '';
  }

  AuthException _handleDioError(DioException error) {
    final type = error.type;
    final response = error.response;

    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout) {
      return NetworkException('Network timeout error. Please check your internet connection.');
    }

    if (response != null) {
      final statusCode = response.statusCode;
      if (statusCode == 401) {
        return InvalidCredentialsException('Invalid username or password.');
      } else {
        return ServerException('Server error. Status code: $statusCode');
      }
    }
    return NetworkException('Network error. Please check your internet connection.');
  }
}
