import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../core/constants/constant.dart';
import '../../../core/services/shared_preferences_service.dart';
import '../../../dependency_injections.dart';
import '../../models/input_data/organization_model.dart';

class RemoteOrganizationProvider {
  const RemoteOrganizationProvider({required Dio dio}) : _dio = dio;
  final Dio _dio;

  static final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Future<List<OrganizationModel>> getOprOrganizations() async =>
      _executeRequest<List<OrganizationModel>>(
        () async {
          int timestamp = DateTime.now().millisecondsSinceEpoch;
          String? cookie =
              serviceLocator<SharedPreferencesService>().getCookie();

          Map<String, String> headers = {
            'Cookie': 'siklonsession=$cookie',
            ..._defaultHeaders,
          };

          Response response = await _dio.post(
            '${Constant.baseUrl}/index.php/organization/index.mod?_dc=$timestamp',
            data: _buildOrganizationListRequestData(),
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
                    OrganizationModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        },
        'fetch opr organizations',
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

  Map<String, dynamic> _buildOrganizationListRequestData() => {
        'select': jsonEncode([
          'organization_id',
          'organization_name',
          'organization_name',
        ]),
        'sorter': jsonEncode([]),
        'filter': 'kantor',
        'picklist': 'true',
        'refSource': null,
        'field_name': 'oprincomingreceipt_branch',
        'picklistParam': null,
        'ingnoreCheck': null,
        'fiter_param': jsonEncode({}),
        'page': '1',
        'start': '0',
        'limit': '50',
      };
}
