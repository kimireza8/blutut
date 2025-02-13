import 'package:blutut_clasic/data/models/login_request_model.dart';
import 'package:blutut_clasic/domain/exceptions/auth_exceptions.dart';
import 'package:dio/dio.dart';

import '../../core/constants/constant.dart';

class RemoteAuthProvider {
  final Dio _dio;

  static const String _sessionCookieName = 'siklonsession';

  static final _loginHeaders = {
    "Accept": "application/json, text/javascript, */*; q=0.01",
    "Content-Type": "application/x-www-form-urlencoded",
    "Origin": Constant.baseUrl,
    "Referer": '${Constant.baseUrl}/index.php/auth/',
    "X-Requested-With": "XMLHttpRequest",
  };

  const RemoteAuthProvider({required Dio dio}) : _dio = dio;

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

  String _extractSessionToken(List<String> cookies) {
    String? lastCookie;
    for (final cookie in cookies) {
      final cookieParts = cookie.split(';');
      final cookieNameValue = cookieParts[0].split('=');
      final cookieName = cookieNameValue[0].trim();
      final cookieValue = cookieNameValue[1].trim();
      if (cookieName == _sessionCookieName) {
        lastCookie = "$_sessionCookieName=$cookieValue";
        break;
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
