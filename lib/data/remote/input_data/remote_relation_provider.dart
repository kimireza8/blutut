import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../core/constants/constant.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../models/input_data/relation_model.dart';

class RemoteRelationProvider {
  const RemoteRelationProvider({required Dio dio}) : _dio = dio;
  final Dio _dio;

  static final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Future<List<RelationModel>> getOperationalRelations() async =>
      _executeRequest<List<RelationModel>>(
        () async {
          String? cookie =
              serviceLocator<SharedPreferencesService>().getCookie();
          int timestamp = DateTime.now().millisecondsSinceEpoch;

          Map<String, String> headers = {
            'Cookie': 'siklonsession=$cookie',
            ..._defaultHeaders,
          };

          Response response = await _dio.post(
            '${Constant.baseUrl}/index.php/oprcustomer/index.mod?_dc=$timestamp',
            data: _buildRelationListRequestData(),
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
                (json) => RelationModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        },
        'fetch operator relations',
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

  Map<String, dynamic> _decodeResponseData(responseData) {
    if (responseData is String) {
      return jsonDecode(responseData) as Map<String, dynamic>;
    } else if (responseData is Map) {
      return responseData as Map<String, dynamic>;
    } else {
      return <String, dynamic>{};
    }
  }

  bool _isValidResponse(Map<String, dynamic> responseData) =>
      responseData.containsKey('rows') && responseData['rows'] is List;

  Map<String, dynamic> _buildRelationListRequestData() => <String, dynamic>{
        'select': jsonEncode([
          'oprcustomer_id',
          'oprcustomer_code',
          'oprcustomer_name',
          'oprcustomer_phone',
          'oprcustomer_oprincomingreceipt__oprincomingreceipt_number',
          'oprcustomer_oprincomingreceipt__oprincomingreceipt_date',
          'oprcustomer_address',
        ]),
        'advsearch': null,
        'prefilter': null,
        'sorter': jsonEncode([]),
        'grouper': jsonEncode([]),
        'flyoversearch': jsonEncode([]),
        'page': '1',
        'start': '0',
        'limit': '10',
      };
}
