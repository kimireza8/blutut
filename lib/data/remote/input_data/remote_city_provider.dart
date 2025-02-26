import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

import '../../../core/constants/constant.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../models/input_data/consignee_city_model.dart';

class RemoteCityProvider {
  const RemoteCityProvider({required Dio dio}) : _dio = dio;
  final Dio _dio;

  static final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
  };

  Future<List<ConsigneeCityModel>> getConsigneeCities() async =>
      _executeRequest<List<ConsigneeCityModel>>(
        () async {
          int timestamp = DateTime.now().millisecondsSinceEpoch;
          String? cookie =
              serviceLocator<SharedPreferencesService>().getCookie();

          Map<String, String> headers = {
            'Cookie': 'siklonsession=$cookie',
            ..._defaultHeaders,
          };

          Response response = await _dio.post(
            '${Constant.baseUrl}/index.php/city/index.mod?_dc=$timestamp',
            data: _buildCityListRequestData(),
            options: Options(headers: headers),
          );

          Map<String, dynamic> responseData =
              _decodeResponseData(response.data);

          if (!_isValidResponse(responseData)) {
            throw Exception(
              'Invalid API response format: Missing or incorrect "rows" key',
            );
          }

          List<dynamic> rows = responseData['rows'] as List? ?? [];
          return rows
              .map(
                (json) =>
                    ConsigneeCityModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        },
        'fetch consignee cities',
      );

  Future<T> _executeRequest<T>(
    Future<T> Function() request,
    String operationName,
  ) async {
    try {
      return await request();
    } on DioException catch (e) {
      log('Dio Error: ${e.message}, ${e.response?.statusCode}, ${e.response?.data}');
      throw Exception('API error during $operationName: ${e.message}');
    } catch (e) {
      log('Error: $e');
      throw Exception('Unexpected error during $operationName: $e');
    }
  }

  bool _isValidResponse(Map<String, dynamic> responseData) =>
      responseData.containsKey('rows') && responseData['rows'] is List;

  Map<String, dynamic> _decodeResponseData(responseData) {
    if (responseData is String) {
      return jsonDecode(responseData) as Map<String, dynamic>;
    } else if (responseData is Map) {
      return responseData as Map<String, dynamic>;
    } else {
      return <String, dynamic>{};
    }
  }

  Map<String, dynamic> _buildCityListRequestData() => {
        'select': jsonEncode([
          'city_id',
          'city_code',
          'city_citytype__citytype_shortname',
          'city_name',
          'city_province__province_name',
        ]),
        'advsearch': null,
        'prefilter': jsonEncode([
          {
            'field_name': 'city_province__province_id',
            'field_value': null,
          }
        ]),
        'sorter': jsonEncode([
          {
            'field_name': 'city_province__province_name',
            'sort': 'ASC',
          },
          {
            'field_name': 'city_name',
            'sort': 'ASC',
          }
        ]),
        'grouper': jsonEncode([]),
        'flyoversearch': jsonEncode([]),
        'page': '1',
        'start': '0',
      };
}
