import 'package:dio/dio.dart';

import '../utils/exceptions/auth_exceptions.dart';

class DioErrorUtil {
  static AuthException handleDioError(DioException error) {
    DioExceptionType type = error.type;
    Response? response = error.response;

    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout) {
      return NetworkException(
        'Network timeout error. Please check your internet connection.',
      );
    }
    if (response != null) {
      int? statusCode = response.statusCode;
      if (statusCode == 401) {
        return InvalidCredentialsException('Invalid username or password.');
      } else {
        return ServerException('Server error. Status code: $statusCode');
      }
    }
    return NetworkException(
      'Network error. Please check your internet connection.',
    );
  }
}
