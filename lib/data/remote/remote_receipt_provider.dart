import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../core/constants/constant.dart';
import '../../domain/entities/receipt_entity.dart';
import '../models/detail_shipment_model.dart';
import '../models/shipment_model.dart';

class RemoteReceiptProvider {
  const RemoteReceiptProvider({required Dio dio}) : _dio = dio;
  final Dio _dio;
  static final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  Future<List<ShipmentModel>> getOprIncomingReceipts(
    String cookie, {
    String? searchQuery,
    int? page,
  }) async =>
      _executeReceiptRequest<List<ShipmentModel>>(
        () async {
          int timestamp = DateTime.now().millisecondsSinceEpoch;
          Map<String, String> headers = {
            'Cookie': 'siklonsession=$cookie',
            ..._defaultHeaders,
          };

          Response response = await _dio.post(
            '${Constant.baseUrl}/index.php/oprincomingreceipt/index.mod?_dc=$timestamp',
            data: _buildReceiptListRequestData(
              searchQuery: searchQuery,
              page: page,
            ),
            options: Options(headers: headers),
          );

          Map<String, dynamic> responseData =
              _decodeResponseData(response.data);

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
        },
        'fetch incoming receipts',
      );
  Future<DetailShipmentModel> getDetailprOutgoingReceipts(
    String cookie,
    String id,
  ) async =>
      _executeReceiptRequest<DetailShipmentModel>(
        () async {
          int timestamp = DateTime.now().millisecondsSinceEpoch;
          Map<String, String> headers = {
            'Cookie': 'siklonsession=$cookie',
            ..._defaultHeaders,
          };

          Response response = await _dio.get(
            '${Constant.baseUrl}/index.php/oprincomingreceipt/detail.mod?_dc=$timestamp&primary_key=$id',
            options: Options(headers: headers),
          );

          Map<String, dynamic> responseData =
              _decodeResponseData(response.data);

          if (!_isValidDetailResponse(responseData)) {
            throw Exception(
              'Invalid API response format: Missing or incorrect "row" key in detail receipt response',
            );
          }

          if (_isSuccessResponse(response)) {
            dynamic row = responseData['row'] ?? {};
            return DetailShipmentModel.fromJson(row as Map<String, dynamic>);
          } else {
            throw Exception('Failed to fetch data');
          }
        },
        'fetch receipt detail',
      );

  Future<T> _executeReceiptRequest<T>(
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

  bool _isValidDetailResponse(Map<String, dynamic> responseData) =>
      responseData.containsKey('row') && responseData['row'] is Map;

  bool _isSuccessResponse(Response<dynamic> response) =>
      response.statusCode == 200;

  Map<String, dynamic> _buildReceiptListRequestData({
    String? searchQuery,
    int? page,
  }) {
    Map<String, dynamic> requestData = {
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
      'page': page?.toString() ?? '1',
      'start': (((page ?? 1) - 1) * 5).toString(),
      'limit': '10',
    };
    if (searchQuery != null && searchQuery.isNotEmpty) {
      requestData['filter'] = searchQuery;
    } else {
      requestData['filter'] = null;
    }
    return requestData;
  }

  Future<void> createReceipt(String cookie, ReceiptEntity receipt) async {
  await _executeReceiptRequest<void>(
    () async {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      Map<String, String> headers = {
        'Cookie': 'siklonsession=$cookie',
        ..._defaultHeaders,
      };

      Map<String, dynamic> requestData = {
        '_json': jsonEncode({
          'oprincomingreceipt_branch': receipt.branch,
          'oprincomingreceipt_date': receipt.date,
          'oprincomingreceipt_incomingdate': receipt.incomingDate,
          'oprincomingreceipt_oprcustomer': receipt.customer,
          'oprincomingreceipt_oprcustomerrole': receipt.customerRole,
          'oprincomingreceipt_shippername': receipt.shipperName,
          'oprincomingreceipt_shipperaddress': receipt.shipperAddress,
          'oprincomingreceipt_shipperphone': receipt.shipperPhone,
          'oprincomingreceipt_consigneename': receipt.consigneeName,
          'oprincomingreceipt_consigneeaddress': receipt.consigneeAddress,
          'oprincomingreceipt_consigneecity': receipt.consigneeCity,
          'oprincomingreceipt_consigneephone': receipt.consigneePhone,
          'oprincomingreceipt_receiptnumber': receipt.receiptNumber,
          'oprincomingreceipt_passdocument': receipt.passDocument,
          'oprincomingreceipt_oprkindofservice': receipt.kindOfService,
          'oprincomingreceipt_oprroute': receipt.route,
          'oprincomingreceipt_totalcollies': receipt.totalCollies,
        }),
        
      };

      Response response = await _dio.post(
        'https://app.ptmakassartrans.com/index.php/oprincomingreceiptmobile/insert.mod?_dc=$timestamp',
        data: requestData,
        options: Options(headers: headers),
      );

      if (!_isSuccessResponse(response)) {
        throw Exception('Failed to create receipt: ${response.statusCode}');
      }

      log('Receipt created successfully: ${response.data}');
    },
    'create receipt',
  );
}

}
