import 'package:dio/dio.dart';

import '../../core/constants/constant.dart';
import '../../core/services/shared_preferences_service.dart';
import '../../core/utils/dio_error_util.dart';
import '../../core/utils/exceptions/auth_exceptions.dart';
import '../models/login_request_model.dart';

class RemoteAuthProvider {
  const RemoteAuthProvider({
    required Dio dio,
    required SharedPreferencesService sharedPreferencesService,
  })  : _dio = dio,
        _sharedPreferencesService = sharedPreferencesService;
  final Dio _dio;
  final SharedPreferencesService _sharedPreferencesService;

  Future<String> login(LoginRequest loginRequest) async {
    try {
      Response response = await _dio.post(
        Constant.baseUrl + Constant.loginEndpoint,
        data: {
          'username': loginRequest.username,
          'password': loginRequest.password,
          'remember': loginRequest.rememberMe,
        },
      );
      String token = _extractSessionToken(response.headers['set-cookie'] ?? []);
      await _sharedPreferencesService.setCookie(token);

      int? statusCode = response.statusCode;
      if (statusCode == 401) {
        throw InvalidCredentialsException('Invalid username or password.');
      } else if (statusCode != 200) {
        throw ServerException('Login failed with status code: $statusCode');
      }
      return token;
    } on DioException catch (e) {
      throw DioErrorUtil.handleDioError(e);
    } catch (e) {
      throw AuthException('Unexpected error during login: $e');
    }
  }

  Future<void> logout() async {
    try {
      String? cookie = _sharedPreferencesService.getCookie();
      Response response = await _dio.get(
        '${Constant.baseUrl}/auth/logout/',
        options: Options(headers: {'Cookie': 'siklonsession=$cookie'}),
      );
      int? statusCode = response.statusCode;
      if (statusCode != 200) {
        throw ServerException('Logout failed with status code: $statusCode');
      }
      await _sharedPreferencesService.clearCookie();
    } on DioException catch (e) {
      throw DioErrorUtil.handleDioError(e);
    } catch (e) {
      throw AuthException('Unexpected error during logout: $e');
    }
  }

  String _extractSessionToken(List<String> cookies) {
    String? lastCookie;
    for (final String cookie in cookies) {
      List<String> cookieParts = cookie.split(';');
      String cookieName = cookieParts[0].split('=')[0].trim();
      if (cookieName == 'siklonsession') {
        lastCookie = cookieParts[0].split('=')[1].trim();
      }
    }
    return lastCookie ?? '';
  }

  AuthException handleDioError(DioException error) =>
      DioErrorUtil.handleDioError(error);
}
