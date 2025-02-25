import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/constant.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../core/utils/dio_error_util.dart';
import '../../../core/utils/exceptions/auth_exceptions.dart';
import '../../models/user/user_model.dart';

class RemoteUserProvider {
  const RemoteUserProvider({
    required Dio dio,
    required SharedPreferencesService sharedPreferencesService,
  })  : _dio = dio,
        _sharedPreferencesService = sharedPreferencesService;
  final Dio _dio;
  final SharedPreferencesService _sharedPreferencesService;

  Future<UserModel> getUserInfo() async {
    try {
      String? cookie = _sharedPreferencesService.getCookie();
      Response response = await _dio.post(
        '${Constant.baseUrl}/index.php/usermanagement/info.json',
        options: Options(
          headers: {'Cookie': 'siklonsession=$cookie'},
        ),
      );

      int? statusCode = response.statusCode;
      if (statusCode != 200) {
        throw ServerException(
          'Failed to fetch user info with status code: $statusCode',
        );
      }

      if (response.data == null || response.data.toString().isEmpty) {
        throw Exception('Empty response data received from API');
      }

      dynamic responseData = response.data;
      if (responseData is String) {
        var userData = jsonDecode(responseData) as Map<String, dynamic>;
        return UserModel.fromJson(userData);
      } else if (responseData is Map<String, dynamic>) {
        return UserModel.fromJson(responseData);
      } else {
        throw Exception(
          'Unexpected response format: ${responseData.runtimeType}',
        );
      }
    } on DioException catch (e) {
      throw DioErrorUtil.handleDioError(e);
    } on FormatException catch (e) {
      throw Exception('Failed to decode JSON response: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during user info fetch: $e');
    }
  }
}
