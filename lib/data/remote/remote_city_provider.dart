import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/constants/constant.dart';
import '../../core/services/shared_preferences_service.dart';
import '../../dependency_injections.dart';
import '../models/city_model.dart';

class RemoteCityProvider {
  final Dio _dio;
  const RemoteCityProvider({required Dio dio}) : _dio = dio;

  Future<List<ConsigneeCityModel>> getConsigneeCities() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String? cookie = serviceLocator<SharedPreferencesService>().getCookie();
    try {
      Response response = await _dio.post(
        '${Constant.baseUrl}/index.php/city/index.mod?_dc=$timestamp',
        data: _buildCityListRequestData(),
        options: Options(headers: {
          'Cookie': 'siklonsession=$cookie',
        }),
      );
      Map<String, dynamic> responseData = _decodeResponseData(response.data);

      if (!_isValidResponse(responseData)) {
        throw Exception(
          'Invalid API response format: Missing or incorrect "rows" key',
        );
      }

      List<dynamic> rows = responseData['rows'] as List? ?? [];
      return rows
          .map(
            (json) => ConsigneeCityModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception('API error during fetching cities: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during fetching cities: $e');
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
          'city_name',
          'city_citytype',
        ]),
        'advsearch': null,
        'prefilter': null,
        'sorter': jsonEncode([]),
        'grouper': jsonEncode([]),
        'flyoversearch': jsonEncode([]),
        'page': '1',
        'start': '0',
        'limit': '10',
        'filter': jsonEncode(
          {
            'field_name': 'city_citytype',
            'field_value': 'Consignee',
          },
        ),
      };
}
