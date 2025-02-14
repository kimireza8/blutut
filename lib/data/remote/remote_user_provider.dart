import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/constant.dart';
import '../../core/services/shared_preferences_service.dart';
import '../models/user_model.dart';

class RemoteUserProvider {
  final Dio _dio;
  final SharedPreferencesService _sharedPreferencesService;

  const RemoteUserProvider({
    required Dio dio,
    required SharedPreferencesService sharedPreferencesService,
  })  : _dio = dio,
        _sharedPreferencesService = sharedPreferencesService;

  Future<UserModel> getUserInfo() async {
    try {
      final cookie = _sharedPreferencesService.getCookie();
      log('Cookie: $cookie');
      final response = await _dio.post(
        '${Constant.baseUrl}/index.php/usermanagement/info.json',
        options: Options(headers: {'Cookie': "siklonsession=$cookie"}),
      );

      final statusCode = response.statusCode;
      if (statusCode != 200) {
        throw Exception(
            'Failed to fetch user info with status code: $statusCode');
      }

      if (response.data == null || response.data.toString().isEmpty) {
        throw Exception('Empty response data received from API');
      }

      if (kDebugMode) {
        print('API Response Data: ${response.data}');
      }

      final dynamic responseData = response.data;
      if (responseData is String) {
        final Map<String, dynamic> userData = jsonDecode(responseData);
        return UserModel.fromJson(userData);
      } else if (responseData is Map<String, dynamic>) {
        return UserModel.fromJson(responseData);
      } else {
        throw Exception(
            'Unexpected response format: ${responseData.runtimeType}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on FormatException catch (e) {
      throw Exception('Failed to decode JSON response: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during user info fetch: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    final type = error.type;
    final response = error.response;

    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout) {
      return NetworkException(
          'Network timeout error. Please check your internet connection.');
    }

    if (response != null) {
      final statusCode = response.statusCode;
      return ServerException('Server error. Status code: $statusCode');
    }

    return NetworkException(
        'Network error. Please check your internet connection.');
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}
