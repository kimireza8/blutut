import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/constants/constant.dart';
import '../models/detail_shipment_model.dart';
import '../models/shipping_model.dart';

class RemoteReceiptProvider {
  const RemoteReceiptProvider({required Dio dio}) : _dio = dio;
  final Dio _dio;
  static final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Future<List<ShipmentModel>> getOprIncomingReceipts(String cookie) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    log('cookie opr: $cookie');
    Map<String, String> headers = {
      'Cookie': 'siklonsession=$cookie',
      ..._defaultHeaders,
    };

    try {
      Response response = await _dio.post(
        '${Constant.baseUrl}/index.php/oprincomingreceipt/index.mod?_dc=$timestamp',
        data: _buildReceiptListRequestData(),
        options: Options(headers: headers),
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');

      Map<String, dynamic> responseData = _decodeResponseData(response.data);

      if (!_isValidResponse(responseData)) {
        throw Exception(
          'Invalid API response format: Missing or incorrect "rows" key',
        );
      }

      List<dynamic> data = responseData['rows'] as List? ?? [];
      return data
          .map(
            (json) => ShipmentModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      log('Dio Error: ${e.message}, ${e.response?.statusCode}, ${e.response?.data}');
      throw Exception('Failed to load data: ${e.message}');
    } catch (e) {
      log('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  Future<DetailShipmentModel> getDetailprOutgoingReceipts(
    String cookie,
    String id,
  ) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    Map<String, String> headers = {
      'Cookie': 'siklonsession=$cookie',
      ..._defaultHeaders,
    };

    try {
      Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>(
        '${Constant.baseUrl}/index.php/oprincomingreceipt/detail.mod?_dc=$timestamp&primary_key=$id',
        options: Options(headers: headers),
      );

      if (_isSuccessResponse(response)) {
        dynamic row = response.data?['row'] ?? {};
        return DetailShipmentModel.fromJson(row as Map<String, dynamic>);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
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

  bool _isSuccessResponse(Response<Map<String, dynamic>> response) =>
      response.statusCode == 200 && response.data?['success'] == true;

  Map<String, dynamic> _buildReceiptListRequestData() => {
        'select': jsonEncode([
          'oprincomingreceipt_id',
          'oprincomingreceipt_branch__organization_name',
          'oprincomingreceipt_number',
          'oprincomingreceipt_date',
          'oprincomingreceipt_totalcollies',
          'oprincomingreceipt_colliesnum',
          'oprincomingreceipt_cargonum',
          'oprincomingreceipt_oprkindofservice__oprkindofservice_name',
          'oprincomingreceipt_oprroute__oprroute_name',
          'oprincomingreceipt_oprcustomer__oprcustomer_name',
          'oprincomingreceipt_oprcustomerrole__oprcustomerrole_name',
          'oprincomingreceipt_shippername',
          'oprincomingreceipt_consigneename',
          'oprincomingreceipt_oprincomingreceiptstatus__oprincomingreceiptstatus_name',
        ]),
        'advsearch': null,
        'prefilter': jsonEncode([
          {
            'field_name': 'oprincomingreceipt_branch__organization_id',
            'field_value': null,
          },
          {
            'field_name': 'oprincomingreceipt_year__year_id',
            'field_value': null,
          },
          {
            'field_name': 'oprincomingreceipt_month__month_id',
            'field_value': null,
          },
          {
            'field_name':
                'oprincomingreceipt_oprincomingreceiptstatus__oprincomingreceiptstatus_id',
            'field_value': null,
          }
        ]),
        'sorter': jsonEncode([
          {'field_name': 'oprincomingreceipt_date', 'sort': 'DESC'},
          {'field_name': 'oprincomingreceipt_number', 'sort': 'DESC'},
        ]),
        'grouper': jsonEncode([]),
        'flyoversearch': jsonEncode([]),
        'page': '1',
        'start': '0',
        'limit': '10',
      };
}
