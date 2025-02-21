import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/constants/constant.dart';
import '../../core/services/shared_preferences_service.dart';
import '../../dependency_injections.dart';
import '../models/organization_model.dart';

class RemoteOrganizationProvider {
  final Dio _dio;
  const RemoteOrganizationProvider({required Dio dio}) : _dio = dio;

  Future<List<OrganizationModel>> getOprOrganizations() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String? cookie = serviceLocator<SharedPreferencesService>().getCookie();
    try {
      Response response = await _dio.post(
        '${Constant.baseUrl}/index.php/organization/index.mod?_dc=$timestamp',
        data: _buildOrganizationListRequestData(),
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
            (json) => OrganizationModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception('API error during fetching organizations: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error during fetching organizations: $e');
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

  Map<String, dynamic> _buildOrganizationListRequestData() => {
        'select': jsonEncode([
          'organization_id',
          'organization_name',
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
            'field_name': 'organization_id',
            'field_value': null,
          },
        ),
      };
}
